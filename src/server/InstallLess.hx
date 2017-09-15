package server;

class InstallLess {
  static function main() {
    if (Sys.command('lessc', ['-v']) != 0)
      Sys.command('npm', ['install', 'less']);
  }
}