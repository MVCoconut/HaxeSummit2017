package github;

import tink.http.Header;
import tink.web.proxy.Remote;

class GithubClient extends Remote<Github> {
  static public function connect() {
		return new github.GithubClient(
      new tink.http.clients.JsClient(), 
      { 
        host: new tink.url.Host('localhost:8080'), 
        path: (['api'] : Array<tink.url.Portion>),
        headers: [ 
          new HeaderField('Accepts', 'application/json'), 
          // uncomment the following line after putting your github credentials as user:password in the specified path
          // new HeaderField('Authorization', 'Basic ' + haxe.crypto.Base64.encode(haxe.io.Bytes.ofString(CompileTime.readFile('src/github/credentials.txt'))))
        ]
      }
    );
  }

    
}