{ config, lib, pkgs, ... }:
let
  gitConfig = pkgs.writeText "gitConfig" ''
    [user]
      email = polytope@example.com
      name = polytope
    [alias]
      br = branch
      ci = commit
      co = checkout
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
      environment.shellAliases = {
        g = "git";
        ga = "git add";
        gc = "git commit";
        gd = "git diff";
        gdc = "git diff --cached";
        gpull = "git pull";
        gpush = "git push";
        gst = "git status";
      };

      environment.systemPackages =
        [ pkgs.gitAndTools.git
          pkgs.gitAndTools.git-annex # manage files without committing file contents 
          pkgs.gitAndTools.git-crypt # encrypts particular files
          pkgs.gitAndTools.gitRemoteGcrypt # encrypts an entire repository
        ];
    };
  }
