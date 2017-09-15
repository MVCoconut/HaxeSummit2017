package client;

class Voodoo {
  static public function later<T>(delay:Int, value:Lazy<T>) {
    return Future.async(function (cb) {
      haxe.Timer.delay(function () {
        cb(value.get());
      }, delay);
    });
  }

  static public function throttle<T>(o:Observable<T>, delay:Int) {
    var ret = Observable.create(function () {
      var ret = o.measure();
      
      return new Measurement(
        o.value, 
        later(delay, Noise).merge(ret.becameInvalid, function (_, _) return Noise)
      );
    });
    return ret;
  }  
}