package github;

import haxe.DynamicAccess;
using tink.CoreApi;

typedef UserName = String;
typedef GistId = String;

interface Github {
  @:sub('/gists') function gists():Promise<OwnGists>; 
  @:sub('/users/$name') function user(name:UserName):Promise<GithubUser>;
}

typedef GithubUserDetails = {
  >GithubUserInfo,
  var public_repos(default, null):Int;
  var public_gists(default, null):Int;
  var followers(default, null):Int;
  var following(default, null):Int;  
}

interface OwnGists {
  @:params(since in query)
  @:get('/') function all(?since:GithubDate):Promise<Array<GistInfo>>;
  @:get('/starred') function starred():Promise<Array<GistInfo>>;
  @:sub('/$id') function byId(id:GistId):Promise<Gist>;
  @:post('/') function create(body:GistCreate):Promise<GistDetails>;  
}

@:enum abstract GithubUserType(String) from String to String {
  var User = "User";
  var Organization = "Organization";
}

typedef GithubUserInfo = {
  var id(default, null):Int;
  var login(default, null):UserName;
  var avatar_url(default, null):String;
  var type(default, null):GithubUserType;
}

interface GithubUser {
  
  @:get('/') function info():GithubUserDetails;
  @:sub('/gists') function gists():UserGists;
}

typedef GistCreate = {
  var description:String;
  @:json("public") var isPublic:Bool;
  var files:DynamicAccess<{
    content:String
  }>;
}

typedef GistEdit = {
  var description:String;
  var files:DynamicAccess<Null<{
    content:String
  }>>;
}

interface UserGists {
  @:get('/') function all():Array<GistInfo>;
}

interface Gist {
  @:get('/') function details():GistDetails;
  @:patch('/') function edit(body:GistEdit):{};
}

typedef GithubDate = String;

typedef GistFileInfo = {
  var filename(default, null):String;
  var type(default, null):String;
  @:optional var language(default, null):String;
  var raw_url(default, null):String;
  var size(default, null):Int;
}  

typedef GistFileDetails = {
  >GistFileInfo,
  var truncated(default, null):Bool;
  var content(default, null):String;
}

typedef GistOf<File> = {
  var id(default, null):String;
  @:optional var description(default, null):String;
  var html_url(default, null):String;
  var files(default, null):DynamicAccess<File>;
}

typedef GistInfo = GistOf<GistFileInfo>;

typedef GistDetails = {
  >GistOf<GistFileDetails>,
  
  var forks(default, null):Array<{}>;
  var truncated(default, null):Bool;
  var history(default, null):Array<Change>;
}

typedef Change = {
  var user(default, null): GithubUserInfo;
  var version(default, null):String;
  var url(default, null):String;
  var committed_at(default, null):GithubDate;
  var change_status(default, null):ChangeStatus;
}

typedef ChangeStatus = {
  var total(default, null):Int;
  var additions(default, null):Int;
  var deletions(default, null):Int;
}