package client;

import client.project.*;

class Session implements Model {
  @:editable var projectId:ProjectId;
  @:constant var loadProject:ProjectId->Promise<List<Named<String>>>;
  @:loaded var currentProject:Project = loadProject(projectId).next(FlatDump.makeTree.bind(projectId));
}