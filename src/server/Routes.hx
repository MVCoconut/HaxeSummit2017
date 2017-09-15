package server;

import tink.web.routing.*;

interface Routes extends Api {
  @:get('/static/*') function serveFile(context:Context):Future<tink.http.Response.OutgoingResponse>;
  @:get('/') function app():Response;
}