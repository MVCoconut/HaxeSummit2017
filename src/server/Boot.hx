package server;

import tink.http.containers.*;
import tink.http.Response;
import tink.web.routing.*;
import js.Node.*;

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
      if (Sys.command('haxe', ['server.hxml']) != -1) {
        Sys.println('rebuild successful');
        p.kill();
        Sys.exit(0);
      }
      else
        Sys.println('rebuild failed');
    });

    var router = new Router<Routes>(new Root(__dirname));
    var container = new NodeContainer(8080);
    container.run(function(req) return router.route(Context.ofRequest(req)).recover(OutgoingResponse.reportError));

  }
}