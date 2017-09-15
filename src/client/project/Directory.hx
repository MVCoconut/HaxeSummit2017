package client.project;

class Directory implements Model {
  
  @:observable var entries:List<Named<Entry>> = @byDefault null;

  public function get(name)
    return entries.first(o => o.name == name);

  @:transition function set(name:String, entry:Null<Entry>) 
    return {
      entries: {
        var ret = entries.filter(o => o.name != name);
        if (entry != null)
          ret = ret.append(new Named(name, entry));
        ret;
      }
    }
}