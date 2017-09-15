package client.project;

class Project implements Model {
  
  @:constant var id:ProjectId;
  @:editable var description:String;
  @:constant var root:Directory = @byDefault new Directory();
  @:editable private var _isSaving:Bool = false;

  @:computed var isSaving:Bool = false;
  @:constant private var saveProject:Project->Promise<Noise>;
  
  @:transition function save() {
    if (isSaving)
      return {};
    _isSaving = true;
    return saveProject(this).next(function (_) {
      _isSaving = false;
      return {};
    });
  }
}