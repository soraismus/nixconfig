{ config, lib, pkgs, ... }:
let
  readFile = builtins.readFile;

  useTmux = config.environment.theo.programs.tmux.enable;

  interactive-shell-init-sources =
    [
      (readFile ./functions)
      (readFile ./settings)
      (readFile ./completion)
    ] ++ lib.optionals useTmux [
      (readFile ./tmux-completion)
    ];
in
  {
    options.environment.theo.programs.bash = {
      enable = lib.mkEnableOption "bash";
    };

    config = lib.mkIf config.environment.theo.programs.bash.enable {

      environment = {
        etc."inputrc".source = ./inputrc;

        interactiveShellInit =
          lib.concatMapStrings (x: x + "\n") interactive-shell-init-sources;

        variables =
          rec {
            BOOKMARKPATH = "${CONFIG_ROOT}/bookmarks";
            CONFIG_ROOT = "${VOLATILE_CONFIG}/$USER";
            EDITOR = "vim";
            FILE_ANNOTATIONS = "${CONFIG_ROOT}/.file_annotations";
            HISTCONTROL = "ignoredups:erasedups";
            HISTFILE = "${CONFIG_ROOT}/bash/history/.history";
            HISTFILESIZE = "10000000";
            HISTIGNORE =
              "b:b1:b2:b3:b4:b5:bg:exit:fg:hist:history:ixclip:l:l1:ls:lsm"
                + ":oxclip:promptToggle:pwd:quit"
                + ":startStackShell:togglePrompt:toggleTouchpad"
                + ":touchpadToggle:worto";
            HISTSIZE = "100000";
            MARKPATH = "${CONFIG_ROOT}/.marks";
            NAMESPACES = "/etc/nixos/namespaces";
            NIXOS_UNSTABLE_NIX_PATH =
              "nixpkgs="
                + "https://github.com/NixOS/nixpkgs-channels/archive/"
                + "nixos-unstable.tar.gz";
            PRIV_BKM_PATH = "${CONFIG_ROOT}/private-bookmarks";
            PROMPT_COMMAND = "_promptCommand";
            TAGPATH = "${CONFIG_ROOT}/.tags";
            TAGSOURCES = "${CONFIG_ROOT}/.tag_sources";
            VISUAL = "vim";
            VOLATILE_CONFIG = "/etc/nixos/volatile_config";
            VOLATILE_EXPORTS = "${CONFIG_ROOT}/.volatile_exports";
          };
      };

      programs.bash = {
        completion.enable = true;
        interactiveShellInit = ''
            if [ ! -e "$CONFIG_ROOT/bash/history/" ]; then
              mkdir -p "$CONFIG_ROOT/bash/history/"
            fi
          '';
        loginShellInit = "";
        promptInit = builtins.readFile ./prompt;
        shellAliases = {
          ".." = "cd ..";
          "..." = "cd ../..";
          "...." = "cd ../../..";
          b = "cd ..";
          b1 = "cd ..";
          b2 = "cd ../..";
          b3 = "cd ../../..";
          b4 = "cd ../../../..";
          b5 = "cd ../../../../..";
          date = "date +%Y.%m.%d.%H.%M";
          duf = "duf -hide special -hide-mp /boot,/nix/store";
          format-purs = "format-purs-json-errors-output";
          gco = "git co";
          gcob = "git cob";
          gd = "git diff";
          gdc = "git diff --cached";
          gdiff = "git diff";
          gits = "git s";
          gitst = "git st";
          gs = "git status";
          gst = "git st";
          gti = "git";
          ixclip = "xclip -i -sel clip";
          l = "eza -alhb --group-directories-first --git --tree --level 2 --git-ignore";
          l1 = "eza -1a --group-directories-first";
          ls = "eza -a --group-directories-first";
          oxclip = "xclip -o -sel clip";
          promptToggle = "togglePrompt";
          quit = "exit";
          rm = "rm -I";
          sb = "spago-build-json";
          sbp = "spago-build-json-pretty";
          spago-build-json = "spago -q build --purs-args --no-prefix --purs-args --json-errors";
          spago-build-json-pretty = "spago -q build --purs-args --no-prefix --purs-args --json-errors 2>&1 | grep -v Compiling | format-purs-json-errors-output";
          stackBuild = "NIX_PATH=$NIXOS_UNSTABLE_NIX_PATH stack build --nix --fast";
          startStackShell = "NIX_PATH=$NIXOS_UNSTABLE_NIX_PATH nix-shell -p stack";
          touchpadToggle = "toggleTouchpad";
          v = "vim";
          worto = "vim $MARKPATH/expl/wortolisto";
        };
        shellInit = "";
      };

    };
  }
