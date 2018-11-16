{ config, lib, pkgs, ... }:
let
  gitConfig = pkgs.writeScriptBin "gitConfig" ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.git}/bin/git config --global user.name "polytope"
    ${pkgs.git}/bin/git config --global user.email "polytope@example.com"
    ${pkgs.git}/bin/git config --global alias.br branch
    ${pkgs.git}/bin/git config --global alias.ci commit
    ${pkgs.git}/bin/git config --global alias.co checkout
    ${pkgs.git}/bin/git config --global alias.dump 'cat-file -p'
    ${pkgs.git}/bin/git config --global alias.hist "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short"
    ${pkgs.git}/bin/git config --global alias.st status
    ${pkgs.git}/bin/git config --global alias.type 'cat-file -t'
    ${pkgs.git}/bin/git config --global core.excludesFile ${./ignore}
  '';
in
  {
    options.environment.theo.programs.git = {
      enable = lib.mkEnableOption "git";
    };

    config = lib.mkIf config.environment.theo.programs.git.enable {
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
          gitConfig
        ];
    };
  }
