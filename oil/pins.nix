{ fetchgit, stdenv }:
let
  json = stdenv.lib.importJSON ./src.json;
  fetch-pinned-git-repo = jsonFile: fetchgit {
    inherit (stdenv.lib.importJSON jsonFile) url sha256 rev;
  };
in
  {
    oil = {
      src = fetch-pinned-git-repo ./src.json;
      version = json.rev;
    };
  }
