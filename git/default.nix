{ config, lib, pkgs, ... }:
let
  gitConfig = pkgs.writeText "gitConfig" ''
    [user]
      email = hilty.matthew@pm.me
      name = matthew.hilty
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
      follow = log --follow -p
      hist = log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short
      log0 = log --graph --pretty=format:\"%h %ad | %s%d [%an]\" --date=short
      log1 = log --graph --decorate --pretty=oneline --abbrev-commit
      restorest = restore --staged
      s = status --short --branch
      st = status --short --branch
      type = cat-file -t
      strestore = restore --staged
    [core]
      excludesFile = ${./ignore}
    [grep]
      lineNumber = true
      patternType = perl
    [init]
      defaultbranch = master
    [filter "lfs"]
      clean = git-lfs clean -- %f
      smudge = git-lfs smudge -- %f
      process = git-lfs filter-process
      required = true
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
          pkgs.gitAndTools.tig # text-mode interface for git
          pkgs.git-lfs # extension for versioning large files
        ];
    };
  }
