package ;

import client.project.*;
using tink.CoreApi;

class TestProject extends haxe.unit.TestCase {
  function test() {
    
    var p = FlatDump.makeTree('foo', [
      for (i in 0...10) new Named(
        [for (j in 0...i >> 2) 'sub'].join('/') + '/file$i.txt', 
        'file $i'
      )
    ]).sure();

    switch p.root.get('sub') {
      case Some({ value: Dir(dir) }):
        switch dir.get('sub') {
          case Some({ value: Dir(dir) }):
            switch dir.get('file9.txt') {
              cast Some({ value: File({ content: 'file 9' }) })):
            assertTrue(
          case v:
        }
      default:
    }    
  }
}