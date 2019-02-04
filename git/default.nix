{ config, lib, pkgs, ... }:
let
  gitConfig = pkgs.writeText "gitConfig" ''
    [user]
      email = polytope@example.com
      name = polytope
    [alias]
      br = branch
      ci = commit
      ciam = commit -am
      cim = commit -m
      co = checkout
      cob = checkout -b
      d = diff
      dc = diff --cached
      dump = cat-file -p
      hist = log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short
      st = status
      type = cat-file -t
    [core]
      excludesFile = ${./ignore}
  '';
in
  {
    options.environment.theo.programs.git = {
      enable = lib.mkEnableOption "git";
    };

    config = lib.mkIf config.environment.theo.programs.git.enable {
      environment.etc."gitconfig".source = gitConfig;

      environment.systemPackages =
        [ pkgs.gitAndTools.git
          pkgs.gitAndTools.git-annex # manage files without committing file contents 
          pkgs.gitAndTools.git-crypt # encrypts particular files
          pkgs.gitAndTools.gitRemoteGcrypt # encrypts an entire repository
        ];
    };
  }
