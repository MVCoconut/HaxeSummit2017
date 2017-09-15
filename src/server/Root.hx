package server;

import tink.http.Response;

class Root implements Routes {
  var files:tink.http.Handler;
  public function new(root:String) {
    this.files = new tink.http.middleware.Static.StaticHandler('$root/static', '/static', function (_)
      return Future.sync(OutgoingResponse.reportError(new Error(NotFound, 'not found')))
    );
  }
  public function serveFile(context:tink.web.routing.Context) {
    return files.process(@:privateAccess context.request);
  }
  public function dump(id:String, files:Array<{ name:String, content: String }>):Promise<Noise> {
    return Noise;
  }
  public function app():tink.web.routing.Response
    return index();

  @:template static function index();
}