package client.project;

class Project implements Model {
  
  @:constant var id:ProjectId;
  @:constant var root:Directory = @byDefault new Directory();
  @:computed var content:List<Named<String>> = crawl('.', root);

  static function crawl(path:String, directory:Directory):List<Named<String>> {
    var ret = new List(),
        files = new List();

    for (entry in directory.entries) {
      var name = '$path/${entry.name}';

      switch entry.value {
        case File(file): files = files.append(new Named(name, file.content));
        case Dir(dir): ret = ret.concat(crawl(name, dir));
      }
    }

    return ret.concat(files);
  }

  static public function ofFileList(id:ProjectId, files:List<Named<String>>) {
    
    var root = new Directory();

    for (f in files) {
      
      var parts = [for (part in f.name.split('/')) 
        switch part.trim() { 
          case '' | '.': 
          case v: v;
        }
      ];

      trace(parts);

      var name = parts.pop(),
          cur = root;
      for (p in parts)
        switch cur.get(p) {
          case None:
            var nu = new Directory();
            cur.set(p, Dir(nu));
            cur = nu;
          case Some({ value: Dir(d) }):
            cur = d;
          case Some(other):
            throw 'unreachable ${Std.string(other)} for ${f.name}';
        }

      cur.set(name, File(new File({ content: f.value })));
    }

    return new Project({ id: id, root: root });
  }
}