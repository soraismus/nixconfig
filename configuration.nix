# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./automatic-mac-spoofing
      ./backup
      ./bookmark
      ./execute-namespace
      ./format-purs-json-errors-output
      ./hardware-configuration.nix
      ./git
      ./i3
      ./mdb-to-sql
      ./rofi
    ];

  boot = {
    kernelPackages = pkgs.linuxPackages_6_1;
    kernelParams   = [ "i2c_hid.polling_mode=1" ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  console =
    let
      callPackage = pkgs.lib.callPackageWith pkgs;
      workman = (callPackage ./workman {}).workman;
    in {
      font = "Lat2-Terminus16";
      keyMap = "us";
      packages = [ workman ];
    };

  # bash and inputrc # see also `programs.bash`
  environment = {
    etc."inputrc".source = ./bash/inputrc;
    interactiveShellInit = pkgs.lib.concatStringsSep "\n" [
        (builtins.readFile ./bash/functions)
        (builtins.readFile ./bash/settings)
        (builtins.readFile ./bash/completion)
        (builtins.readFile ./bash/tmux-completion)
      ];
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

  environment.systemPackages =
    let
      myPython = pkgs.python312.withPackages (ps: with ps; [
        arxiv2bib
        beautifulsoup4
        pypdf3
        requests
        scrapy
      ]);
      myRstudio = pkgs.rstudioWrapper.override {
        packages = with pkgs.rPackages; [
          data_table
          dplyr
          ggplot2
          ggraph
          languageserver # LSP for neovim/emacs
          patchwork
          shiny
          tidyr
          tidyverse
        ];
      };
    in
      with pkgs; [
        ############################################################################
        # Core CLI
        ############################################################################
          bat                 # pager + diff highlighter;
                              # a 'cat' clone with syntax highlighting and git integration
          bat-extras.batdiff  # pager + diff highlighter
          broot               # interactive tree view, fuzzy search, balanced BFS descent
          eza                 # ls replacement
          fd                  # fast file-finder
          file                # program that shows the type of files
          fzf                 # fuzzy everything
          jq                  # JSON wrangler
          jqp                 # TUI playground for experimenting with jq
          maim                # cli screenshot utility [cf. scrot]
          mmv                 # utility for wildcard renaming, copying, etc
          renameutils         # batch rename
          ripgrep             # recursive grep
          tldr                # community cheat-sheets
          translate-shell     # command-line translator
          tree                # directory tree
          units               # unit-conversion tool
          unzip               # extraction utility for archives cmopressed in .zip format
          zip                 # compressor/achiver for creating and modifyig zipfiles
        ############################################################################
        # Nix helpers
        ############################################################################
          direnv                # automatic shell envs
          niv                   # dependency manager for nix projects
          nix-direnv            # automatic shell envs
          # lorri               # project-scoped builds
          nix-index
          # nix-index-database  # “which package provides X?”
          nix-diff              # utility that compares nix derivations
          nix-prefetch-git      # nix utility that aids in pinning github revisions
        ############################################################################
        # Shell UX
        ############################################################################
          rofi      # window switcher, run dialog and dmenu replacement
          rofi-pass # script to make rofi work with password-store
        ############################################################################
        # Monitoring & diagnostics
        ############################################################################
          dua                # tool to learn about directories' disk usage
          duf                # disk
          du-dust            # disk
          glances            # processes / resources [cf. htop]
          htop               # interactive process viewer
          iotop              # processes / resources
          iperf3             # tool to measure IP/UDP & IP/TCP bandwith
          mtr                # network-diagnostics tool
          fastfetch          # neofetch-like system-information tool
          powertop           # utility to analyze power consumption on Intel-based laptops
        ############################################################################
        # Networking & security (kept small; heavy stuff via `nix run`)
        ############################################################################
          age           # file encryption tool.
          # burpsuite   # integrated platform for performing security testing
          gnupg         # gnu privacy guard, a gpl openpgp implementation
          hashcat       # password cracker
          hashcat-utils # utilities for advanced password cracking
          macchanger    # utility for manipulating MAC addresses
          nmap          # utitlity for network discovery and security auditing
          openssh       # implementation of the SSH protocol
          openssl       # cryptographic library that implements tsl protocol
          pass          # password-store manages passwords securely
          sops          # secret manager
          tcpdump       # network sniffer
          wget          # tool for retrieving files using http, https, and ftp [cf. curl]
          wireshark-cli # network-protocol analyzer
          xh            # curl alternative for sending http packets
        ############################################################################
        # Editing & terminals
        ############################################################################
          ghostty # gpu terminal
          myVim
          neovim
          tmux
          tmuxp   # manage tmux workspaces from JSON and YAML
          xclip   # clipboard utility
          xdotool # fake keyboard/mouse input, window management
          xdragon # simple drag-and-drop source/sink for x
        ############################################################################
        # Dev tool-chain
        ############################################################################
          # cabal-install # haskell packaging and build system
          # coq_8_9       # coq theorem assistant
          delta           # syntax-highlighting pager for git (diff alternative)
          # gitui         # terminal ide for git (lazygit alternative)
          git             # vcs (version control system)
          # lazygit       # terminal ui for git commands
          # lean4         # automatic and interactive theorem prover
          myPython
          myRstudio
          nodejs_20
          # sageWithDoc   # cas / maths
          sqlite          # self-contained SQL database engine
          sqlite-utils    # CLI utility and library for manipulating SQLite databases
          # stack         # haskell tool stack
          # tig           # text-mode interface for git
        ############################################################################
        # Doc & media
        ############################################################################
          feh                            # light-weight image viewer and screenshot manager
          ffmpeg                         # manager and converter of audio/video files
          # hieroglyphic                 # tex-match; detexify; search by sketching
          # libreoffice                  # open-source office suite
          pandoc                         # utility that translates between markup formats
          pavucontrol                    # pulseaudio volume control
          poppler_utils                  # pdf rendering library
          # qpdf                         # C++ programs that inspect/manipulate PDF files
          # texlive.combined.scheme-full # pdflatex, xcolor.sty for pdf conversion
          # texstudio                    # tex and latex editor
          # typst                        # markup-based typesetting system
          vlc                            # cross-platform media player and streaming server
          # yt-dlp                       # command-line tool to download videos from video platforms
          zathura                        # PDF reader with vim bindings; plugin-based document viewer;
                                         # can use mupdf as plugin
        ############################################################################
        # Browsers
        ############################################################################
          brave         # privacy-oriented browser
          # browsh      # text-based browser that can render css and js (cf. links2, lynx, w3m)
          chromium
          firefox
          # librewolf
          links2        # small browser with graphics support (`-g`) (cf. browsh, lynx, w3m)
          lynx          # terminal web-browser (cf. browsh, links2, w3m)
          # qutebrowser # keyboard-focused browser
          # vieb        # vim-inspired electron browser
          w3m           # text-based web browser (cf. browsh, links2, lynx)
        ############################################################################
        # Consider
        ############################################################################
            # atuin              # db-persisted shell-history manager
            # borgmatic          # configuration-driven backup software
            # calibre            # e-book software (calibredb, ebook-convert, ebook-viewer, etc.)
            # delta              # syntax-highlighting pager for git (diff alternative)
            # difftastic         # syntax-aware diff
            # espanso            # cross-platform text expander
            # evil-helix         # modal text editor (vim alternative)
            # expect             # tool for automating interactive applications
            # ffuf               # fast web fuzzer; web scraper
            # fselect            # find files with SQL-like syntax
            # graphviz           # graph visualization tool
            # hyperfine          # benchmarking tool
            # just / justbuild ? # command runner (make alternative)
            # koreader           # ebook-reader application
            # lc0                # neural-network-based chess engine
            # manim              # animation engine for explanatory mathematics videos
            # manim-slides       # tool for live presenations using manim
            # mprocs             # TUI for running multiple commands
            # neofetch           # fastfetch; neofetch-like system-information tool
            # newsboat           # terminal RSS/Atom-feed reader
            # niri               # scrollable-tiling wayland compositor
            # nom                # terminal RSS-feed reader
            # nushell            # shell inspired by powershell written in rust
            # obsidian           # knowledge base [cf. zk]
            # parallel           # shell tool fro executing jobs in parallel [cf. xargs ?]
            # presenterm         # terminal-based slideshow tool
            # pychess            # GTK chess client
            # scid               # chess database with play and training functionality
            # starship           # customizable prompt for any shell
            # stockfish          # chess engine
            # tokei              # counts files, line, comments, blanks.
            # wiki-tui           # TUI for wikipedia
            # zellij             # tmux alternative
            # zk                 # Zettelkasten note-taking [cf. obsidian]
            # privoxy            # non-caching web proxy with advanced filtering capabilities
            # psmisc             # utilities using the proc file-system (fuser, killall, pstree, etc)
      ];

  environment.theo = {
    programs = {
      # atuin = {
      #   enable = true;
      #   settins = {
      #     # dialect = "uk";
      #     key_path = config.sops.secrets.atuin_key.path; # `config.sops.…`
      #     # sync_address = "https://example.dev";
      #     # sync_frequency = "15m";
      #   };
      # };
      backup.enable = true;
      bookmark.enable = true;
      execute-namespace.enable = true;
      format-purs-json-errors-output.enable = true;
      git.enable = true;
      mdb-to-sql.enable = true;
      rofi.enable = true;
    };
    services = {
      automatic-mac-spoofing.enable = false;
      i3.enable = true;
    };
  };

  hardware.pulseaudio.enable = true;

  i18n = {
      defaultLocale = "en_US.UTF-8";
    };

  networking = {
    firewall = {
      allowedUDPPorts = [ 631 ];
      allowedTCPPorts = [ 631 3000 ];
    };
    hostName = "theo";
    networkmanager.enable = true;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "Sun 03:15";
    };
    extraOptions = ''
        experimental-features = nix-command flakes
      '';
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      cudaSupport = false;
      packageOverrides = pkgs: {
        myVim = import ./vim { pkgs = pkgs; };
      };
    };
    overlays = [ (import ./nixpkgs-mozilla/firefox-overlay.nix) ];
  };

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages =
      let
        callPackage = pkgs.lib.callPackageWith pkgs;
      in
        [ pkgs.powerline-fonts
          pkgs.font-awesome # font-awesome-ttf -> font-awesome
          pkgs.hasklig
          pkgs.inconsolata
          pkgs.ubuntu_font_family
          pkgs.liberation_ttf
          pkgs.unifont
          pkgs.fira-code
          pkgs.iosevka
          pkgs.fira-mono
          pkgs.terminus_font
          pkgs.fira
          (callPackage ./tsundoku-font {})
        ];
  };

  programs = {
    bash = {
      completion.enable = true;
      interactiveShellInit = ''
          if [ ! -e "$CONFIG_ROOT/bash/history/" ]; then
            mkdir -p "$CONFIG_ROOT/bash/history/"
          fi
        '';
      loginShellInit = "";
      promptInit = builtins.readFile ./bash/prompt;
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

    tmux = {
      enable = true;
      aggressiveResize = false;
      baseIndex = 0;
      clock24 = true;
      customPaneNavigationAndResize = true;
      escapeTime = 500;
      extraConfig = builtins.readFile ./tmux/tmux.conf;
      historyLimit = 10000;
      keyMode = "vi";
      newSession = true;
      reverseSplit = true;
      resizeAmount = 10;
      secureSocket = true;
      shortcut = "f";
      terminal = "screen-256color"; # Default value is "screen".
    };

    wireshark = {
      enable = true;
      # dumpcap.enable = true;
    };
  };

  services = {
    avahi = {
      enable = true;
      publish.enable = true;
      publish.userServices = true;
      nssmdns4 = true;
    };
    displayManager.defaultSession = "none+i3";
    libinput.enable = true;
    openssh.enable = true;
    pipewire.enable = lib.mkForce false;
    printing = {
      enable = true;
      browsing = true;
      drivers =
        with pkgs; [
          gutenprint
          hplip
          # hplipWithPlugin
          postscript-lexmark
          brlaser
        ];
      # Note: With this present configuration, CUPS doesn't recognized IPv4,
      # so a 'Bad Request' response is given to any request to http://localhost:631/.
      # IPv6, however, is acceptable, so Navigate to http://[::1]:631/.
      listenAddresses = [ "*:631" ];
      defaultShared = true;
    };
    xserver = {
      enable = true;
      displayManager = {
        sessionCommands = ''
          ${pkgs.xorg.xrdb}/bin/xrdb -load ${./graphical/Xresources} &
        '';
      };
      xkb = {
        layout = "us";
        model = "pc104";
        options = "ctrl:nocaps";
        variant = "";
      };
    };
  };

  # # key_path = config.sops.secrets.atuin_key.path; # `config.sops.…`
  # sops.secrets.atuin_key = {
  #   sopsFiles = ../secrets.yaml;
  # };

  # hardware.sane = {
  #   enable = true;
  #   extraBackends = [ sane-airscan ];  # optional eSCL/WSD driverless scan
  # };

  system.stateVersion = "18.09";
  # `system.stateVersion` records the NixOS release at installation
  # in order to assist with legacy compatibility.
  # The NixOS manual is blunt about this:
  # “Most users should never change this value after the initial install, even when upgrading to a new release.”

  time.timeZone = "America/New_York";

  # New users, don't forget to set a password with ‘passwd’.
  users.users.polytope = {
    isNormalUser = true;
    home = "/home/polytope";
    description = "polytope";
    extraGroups = [
      "audio"
      "networkmanager"
      "video"
      "wheel"
      "wireshark"
    ];
    # openssh.authorizedKeys.keys = [ "ssh-dss AAAAB3Nza... alice@foobar" ];
  };

}
