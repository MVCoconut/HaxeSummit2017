package client.project;

class Project implements Model {
  
  @:constant var id:ProjectId;
  @:constant var root:Directory = @byDefault new Directory();
  
}