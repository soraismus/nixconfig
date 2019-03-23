# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./automatic-mac-spoofing
      ./bookmark
      ./execute-namespace
      ./hardware-configuration.nix
      ./git
      ./i3
      ./rofi
    ];

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  # bash and inputrc # see also `programs.bash`
  environment = {
    etc."inputrc".source = ./bash/inputrc;

    interactiveShellInit = pkgs.lib.concatStringsSep "\n" [
      (builtins.readFile ./bash/functions)
      (builtins.readFile ./bash/settings)
      (builtins.readFile ./bash/direnv-hook)
      (builtins.readFile ./bash/completion)
      (builtins.readFile ./bash/traps)
      ];

    variables =
      let infinite = "-1";
      in rec {
        BOOKMARKPATH = "${CONFIG_ROOT}/bookmarks";
        CONFIG_ROOT = "${VOLATILE_CONFIG}/$USER";
        EDITOR = "vim";
        FILE_ANNOTATIONS = "${CONFIG_ROOT}/.file_annotations";
        HISTCONTROL = "ignoredups:erasedups";
        HISTFILE = "${CONFIG_ROOT}/bash/history/.history";
        HISTFILESIZE = infinite;
        HISTSIZE = infinite;
        MARKPATH = "${CONFIG_ROOT}/.marks";
        NAMESPACES = "/etc/nixos/namespaces";
        PRIV_BKM_PATH = "${CONFIG_ROOT}/private-bookmarks";
        PROMPT_COMMAND = "prompt_command";
        TAGPATH = "${CONFIG_ROOT}/.tags";
        VOLATILE_CONFIG = "/etc/nixos/volatile_config";
        VOLATILE_EXPORTS = "${CONFIG_ROOT}/.volatile_exports";
      };
  };

  environment.systemPackages =
    let
      # http://fontforge.github.io/en-US/documentation/utilities/
      # Tools include showttf, ttf2eps, pfadecrypt, pcl2ttf.
      fonttools = pkgs.fontforge-fonttools;
    in
      with pkgs; [
        # xorg.xmodmap # https://wiki.xfce.org/faq
        # xorg.xev     # https://wiki.xfce.org/faq
        ag # silver-searcher
        # autossh # automatically restart SSH sessions and tunnels
        bc # calculator
        browsh # text-based browser that can render css and js (cf. links2, lynx, w3m)
        cabal-install # haskell packaging and build system
        cabal2nix # nix utility that transforms cabal specs into nix specs
        chromium # browser
        # conky # configurable X system monitor
        coq # interactive theorem prover
        ctags # utility for fast source-code browsing (exuberant ctags)
        dragon-drop # Simple drag-and-drop source/sink for X
        dhall # non-Turing-complete specification language
        direnv # environment switcher for the shell
        docker # containerizer; OS-level virtualization: application container
        # ekiga # VOIP/video-conferencing app with full SIP and H.323 support
        elmPackages.elm # haskell-like frontend development platform
        feh # light-weight image viewer
        firefox-wrapper # browser
        fontforge-gtk # font editor with GTK UI
        fonttools
        fzf # command-line fuzzy finder
        gitless # version control system built on top of git
        gnupg # GNU Privacy Guard, a GPL OpenPGP implementation
        gdrive # command-line utility for interacting with google drive
        haskellPackages.hakyll # static website compiler library
        heroku
        # hlint
        htop # interactive process viewer
        hound # fast code searching (react frontend; go backend; regex w/ trigram index)
        idris # haskell-like compiler with dependent types
        # inkscape # vector-graphics editor
        iotop
        irssi # terminal-based IRC client
        jitsi # open-source video calls and chat
        jq # command-line json processor
        libnotify # library that sends desktop notifications to a notification daemon
        libreoffice # open-source office suite
        # libtoxcore_0_2 # P2P FOSS instant-messaging application to replace Skype
        links2 # small browser with graphics support (`-g`) (cf. browsh, lynx, w3m)
        lsof # utility to list open files
        lynx # terminal web-browser (cf. browsh, links2, w3m)
        # mitmproxy # man-in-the-middle proxy (recommended unix analogue for fiddler)
        mkpasswd # front-end for crypt (to make initial hashed pw: `mkpasswd -m sha-512`)
        # mopidy # extensible music server that plays music from local, Spotify, etc.
        mongodb # nosql database
        mupdf # parsing engine for PDF, XPS, and EPUB
        myVim # text editor
        # newsboat # fork of Newsbeuter, an RSS/Atom feed reader for the text console
        nix-bash-completions
        nix-diff # utility that compares nix derivations
        nixops # utility for provisioning NixOS machines
        nix-prefetch-git # nix utility that aids in pinning github revisions
        nodejs-10_x # javascript engine
        pandoc # utility that translates between markup formats
        pass # password-store manages passwords securely
        patchelf
        pavucontrol # PulseAudio volume control
        # pijul # distributed version control system inspired by categorical patches
        powertop # utility to analyze power consumption on Intel-based laptops
        # privoxy # non-caching web proxy with advanced filtering capabilities
        psmisc # utilities using the proc file-system (fuser, killall, pstree, etc)
        python
        qtox # Qt tox client
        qutebrowser # keyboard-focused browser with minimal GUI
        ranger # file manager
        ripgrep # regex utility that's faster than the silver searcher ['rg']
        rofi # window switcher, run dialog and dmenu replacement
        rofi-pass # script to make rofi work with password-store
        # rxvt_unicode # clone of rxvt (color vt102 terminal emulator)
        scrot # command-line screen-capture utility
        stack # haskell tool stack
        stack2nix # nix utility that transforms stack specs into nix specs
        tcpdump # network sniffer
        termite # keyboard-centric VTE-based terminal
        # tig # text-mode interface for git
        # tinc # VPN daemon with full mesh routing
        tmux # terminal multiplexer
        # tmuxp # manage tmux workspaces from JSON and YAML
        tmuxinator # tmux-session manager (implemented in ruby)
        # tomb # file encryption
        translate-shell # command-line translator
        tree # commandline directory visualizer
        utox # (mu-tox) lightweight tox client
        virtualbox # hosted hypervisor (hardware virtualization); virtual-machine manager
        vlc # cross-platform media player and streaming server
        w3m # text-based web browser (cf. browsh, links2, lynx)
        xclip # clipboard utility
        yarn # variant to npm
        # yi
        youtube-dl # command-line tool to download videos from video platforms
        zathura # PDF reader with vim bindings; plugin-based document viewer; can use mupdf as plugin
        zim # desktop wiki
      ];

  environment.theo.programs.bookmark.enable = true;
  environment.theo.programs.execute-namespace.enable = true;
  environment.theo.programs.git.enable = true;
  environment.theo.programs.rofi.enable = true;
  environment.theo.services.automatic-mac-spoofing.enable = false;
  environment.theo.services.i3.enable = true;

  i18n =
    let
      callPackage = pkgs.lib.callPackageWith pkgs;
      workman = (callPackage ./workman {}).workman;
    in {
      consoleFont = "Lat2-Terminus16";
      consoleKeyMap = "us";
      defaultLocale = "en_US.UTF-8";
      consolePackages =
        [ pkgs.kbdKeymaps.dvp
          pkgs.kbdKeymaps.neo
          workman # workman-p keyboard layout; see `services.xserver`
        ];
    };

  networking.hostName = "theo"; # Define your hostname.
  networking.networkmanager.enable = true;

  nix.gc = {
    automatic = true;
    dates = "23:00";
  };

  nixpkgs.config = {
    packageOverrides = pkgs: {
      myVim = import ./vim { pkgs = pkgs; };
    };
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts =
      [ pkgs.powerline-fonts
        pkgs.font-awesome-ttf
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
      ];
  };

  programs = {
    bash = {
      enableCompletion = true;
      interactiveShellInit = ''
          if [ ! -e "$CONFIG_ROOT/bash/history/" ]; then
            mkdir -p "$CONFIG_ROOT/bash/history/"
          fi
        '';
      loginShellInit = "";
      promptInit = builtins.readFile ./bash/prompt;
      shellAliases = {
        b = "cd ..";
        b1 = "cd ..";
        b2 = "cd ../..";
        b3 = "cd ../../..";
        b4 = "cd ../../../..";
        b5 = "cd ../../../../..";
        gco = "git co";
        gcob = "git cob";
        gd = "git diff";
        gdiff = "git diff";
        gitst = "git status";
        gst = "git status";
        l = "ls -alh --color=tty";
        ls = "ls -a --color=tty --group-directories-first";
        quit = "exit";
        v = "vim";
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
      extraTmuxConf = builtins.readFile ./tmux/tmux.conf;
      historyLimit = 10000;
      keyMode = "vi";
      newSession = true;
      reverseSplit = true;
      resizeAmount = 10;
      secureSocket = true;
      shortcut = "f";
      terminal = "screen-256color"; # Default value is "screen".
    };
  };

  services.mongodb.enable = true;
  services.openssh.enable = true;

  # Ctrl-Alt-F8 displays the manual in the terminal.
  services.nixosManual.showManual = true;

  services.xserver = {
    enable = true;
    desktopManager = {
      default = "none";
      xterm.enable = false;
    };
    displayManager = {
      auto = {
        enable = true;
        user = "theo";
      };
      sessionCommands = ''
        ${pkgs.xlibs.xrdb}/bin/xrdb -load ${./graphical/Xresources} &
      '';
    };
    layout = "us";
    synaptics.enable = true; # touchpad
    xkbModel = "pc104";
    xkbOptions = "ctrl:nocaps";
    xkbVariant = "";
    windowManager.default = "i3";
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  system.stateVersion = "18.09"; # Change only when NixOS release notes say so.

  time.timeZone = "America/New_York";

  # New users, don't forget to set a password with ‘passwd’.
  users.users.polytope = {
    isNormalUser = true;
    home = "/home/polytope";
    description = "polytope";
    extraGroups = [ "audio" "networkmanager" "video" "wheel" ];
    # openssh.authorizedKeys.keys = [ "ssh-dss AAAAB3Nza... alice@foobar" ];
  };

}
