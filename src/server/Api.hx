package server;

interface Api {
  @:put('/$id') function dump(files:Array<{ name:String, content: String }>):Promise<Noise>;
}