package server;

import tink.http.containers.*;
import tink.http.Response;
import tink.http.Request;
import tink.http.Header;
import tink.web.routing.*;
import js.Node.*;
using tink.io.Source;

class Boot {

  static function changed(dir:String)
    return Future.async(function (cb) {
      js.node.Fs.watch(dir, { recursive: true, persistent: false }, function (_, _) {
        cb(Noise);
      });
    });

  static function main() {
    var p = js.node.ChildProcess.spawn('haxe', ['--wait', '6000']);
    changed('./src/server').handle(function () {
      Sys.println('source change detected');
      if (Sys.command('haxe', ['server.hxml']) == 0) {
        Sys.println('rebuild successful');
        p.kill();
        Sys.exit(0);
      }
      else
        Sys.println('rebuild failed');
    });

    var port = 8080;

    var router = new Router<Routes>(new Root(__dirname));
    var container = new NodeContainer(port);
    var client = new tink.http.clients.SecureNodeClient();
    
    container.run(function(req:IncomingRequest) {
      trace(req.header.url.path);
      return switch req.header.url.path.parts() {
        case api if (api[0] == 'api'):
          
          var host = 'localhost:$port';
          var fields = [for (h in req.header) switch h.name {
            case (_:String) => 'referer' | 'origin': continue;
            case HOST: 
              host = h.value;
              new HeaderField(HOST, 'api.github.com');
            default: h;
          }];
          client.request(
            new OutgoingRequest(
              new OutgoingRequestHeader(
                req.header.method, 
                'https://api.github.com/'+(req.header.url.pathWithQuery:String).substr(4),
                fields
              ),
              switch req.body {
                case Plain(v): 
                  v.idealize(function (_) return Source.EMPTY);
                case Parsed(_): 
                  trace('received parsed body oO');
                  '';
              }
            )
          ).next(function (res) 
            return new OutgoingResponse(
              new ResponseHeader(
                switch res.header.statusCode {
                  case 301: 307;
                  case v: v;
                }, res.header.reason, 
                [for (f in res.header) switch (f.name:String) {
                  case SET_COOKIE: new HeaderField('set-cookie', (f.value:String).split('domain=')[0]);
                  case LOCATION: new HeaderField('location', (f.value:String).replace('https://api.github.com', 'http://$host/api'));
                  default: f;
                }]
              ),
              res.body.idealize(function (_) return Source.EMPTY)
            )
          ).recover(OutgoingResponse.reportError);   
        case v:
          router.route(Context.ofRequest(req)).recover(OutgoingResponse.reportError); 
      }
    });

  }
}