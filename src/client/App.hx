package client;

import client.project.*;
import client.Session;
import js.Browser.*;

@:less('app.less')
@:tink
class App {
  
  static var gh = github.GithubClient.connect();
  static var server = new ServerProxy();

  static function main() {

    gh.gists()
      .all().next(function (gists) return gists[0].id).handle(function (o) switch o {
        case Failure(e): alert(e.message);
        case Success(id):
          launch(id);
      });

  }

  static function saveProject(p:Project) {
    return Promise.lift(Noise);
  }

  static function launch(id:ProjectId) {
    var session = new Session({
      projectId: id,
      loadProject: 
        function (id) 
          return gh.gists().byId(id).details()
            .next(function (gist) return 
              FlatDump.makeTree([for (name => file in gist.files) new Named(name, file.content)])
                .map(function (root) return {
                  root: root,
                  description: gist.description,
                })
            )
            .next(function (info)
              return new Project({
                id: id,
                root: info.root,
                description: info.description,
                saveProject: saveProject,
              })
            )

      
    });

    Observable.auto(
      function () 
        return switch session.currentProject {
          case Done(p): 
            Some({ 
              id: p.id, 
              files: [for (file in FlatDump.crawl('.', p.root)) { 
                name: file.name.substr(2).urlEncode(), 
                content: file.value 
              }]
            });
          default: None;
        }
    ).throttle(1000).bind(function (o) switch o {
      case Some(p):
        server.dump(p.id, p.files);
      case None:
    });
  }

}