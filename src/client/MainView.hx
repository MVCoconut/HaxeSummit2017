package client;

import client.project.*;

@:less('main-view.less')
class Useless {}

class MainView extends View<{ project:Promised<Project>}> {
  function render() '
    <div class="main-view">
      <switch {project}>
        <case {Done(p)}> 
          <h1>{p.description}</h1>
          <button onclick={p.save} disabled={p.isSaving}>Save</button>
          <directory name="." root={p.root} />
        <case {Loading}> 
          <span>Loading ... </span>
        <case {Failed(e)}> 
          <span class="error">Ohnooo!!!</span>
      </switch>
    </div>
  ';

  function directory(options:{ name: String, root: Directory }) '
    <ul class="directory">
      <for {entry in options.root.entries}>
        <li>
          <switch {entry.value}>
            <case {Dir(dir)}>
            <case {File(f)}>
              <span>{options.name}/{entry.name}</span>
              <textarea oninput={f.content = event.target.value}>{f.content}</textarea>
          </switch>
        </li>
      </for>
    </ul>
  ';
}