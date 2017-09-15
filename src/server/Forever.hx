package server;

import Sys.*;

class Forever {
  static function main() {
    var args = args().copy();
    var cmd = args.shift();
    var errors = 0;
    while (errors < 10) {
      println('running $cmd with $args');
      errors = 
        switch Sys.command(cmd, args) {
          case 0: 
            0;
          case v: 
            println('[ERROR] exited with code $v');
            errors + 1;
        }
    }
  }
}