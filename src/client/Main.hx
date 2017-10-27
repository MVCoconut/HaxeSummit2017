package client;

import tink.state.Observable;
import tink.state.State;

class Main {
  static function person(first:String, last:String) {
    return {
      firstName: new State(first),
      lastName: new State(last),
    }
  }
  static function main() {

    var jacques = person('Jacques', 'Cousteau');
    var john = person('John', 'Doe');

    var isJacquesIncharge = new State(true);
    var a = [0];
    var number = Observable.auto(function () return a[0]);
    a[0] = 123;
    var leader = Observable.auto(function () {
      return 
        if (isJacquesIncharge.value) jacques;
        else john;
    });

    var fullName = Observable.auto(function () {
      return '${leader.value.firstName.value} ${leader.value.lastName.value}';
    });

    // var fullName = firstName.observe().combine(lastName, function (first, last) {
    //   trace('compute');
    //   return '$last, $first';
    // });
    // return;
    var htmlFullName = Observable.auto(function () {
      '<h1>${leader.value.firstName} is in charge now</h1>';
    });
    fullName.bind(function(o) {
      trace(o);
    });
    var queue:Array<Void->Void> = [
      function () john.firstName.set('Paul'),
      function () isJacquesIncharge.set(false),
      function () {
        john.firstName.set('Brad');
        // firstName.set('John');
        // lastName.set('Doe');
      }
    ];
    var timer = new haxe.Timer(100);

    timer.run = function () {
      switch queue.shift() {
        case null: timer.stop();
        case f: f();
      }
    };
  }
}