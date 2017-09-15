package client;

import client.project.*;
import client.Session;

@:less('app.less')
class App {
  static function main() {
    var client = github.GithubClient.connect();
    
    client.gists()
      .all().next(function (gists) return gists[0].id);

    // Observable.auto(FlatDump.ofProject.bind(p)).throttle(1000).bind(function (o) trace(o.length));
    
    // var t = new haxe.Timer(100);
    
    // t.run = function () {
    //   p.root.set(
    //     'File${p.root.entries.length}.txt', 
    //     File(new File({ content: 'Hello at ${Date.now()}' }))
    //   );
    // }

  }

}