package server;

interface Api {
  @:params(files in body)
  @:put('/$id') function dump(id:String, files:Array<{ name:String, content: String }>):Promise<Noise>;
}