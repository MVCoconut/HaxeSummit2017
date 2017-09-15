package client;

class ServerProxy extends tink.web.proxy.Remote<server.Api> {
  public function new() {
    super(new tink.http.clients.JsClient(), {
      host: new tink.url.Host('localhost', 8080)
    });
  }
}