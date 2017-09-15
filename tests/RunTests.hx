package tests;

class RunTests {
  static function main() {
    
    var runner = new haxe.unit.TestRunner();
    
    runner.add(new TestProject());

    travix.Logger.exit(
      if (runner.run()) 0
      else 500
    );
  }
}