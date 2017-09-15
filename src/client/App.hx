package client;

import client.project.*;
import client.Session;

@:less('app.less')
class App {
  static function main() {
    var p = Project.ofFileList('foo', [
      for (i in 0...10) new Named(
        [for (j in 0...i >> 2) 'sub'].join('/') + '/file$i.txt', 
        'file $i'
      )
    ]);
    switch p.root.get('sub') {
      case Some({ value: Dir(dir) }):
        switch dir.get('sub') {
          case Some({ value: Dir(dir) }):
            trace(dir.get('file9.txt'));
          case v:
        }
      default:
    }
    js.Browser.console.log(p);
    return;

    p.observables.content.throttle(1000).bind(function (o) trace(o.length));
    
    var t = new haxe.Timer(100);
    
    t.run = function () {
      p.root.set(
        'File${p.root.entries.length}.txt', 
        File(new File({ content: 'Hello at ${Date.now()}' }))
      );
    }

  }

}