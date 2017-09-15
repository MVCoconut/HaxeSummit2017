package client;

import client.project.*;

class Session implements Model {
  @:editable var projectId:ProjectId;
  
  @:constant private var loadProject:ProjectId->Promise<Project>;

  @:loaded var currentProject:Project = loadProject(projectId);

}