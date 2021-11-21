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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  console =
    let
      callPackage = pkgs.lib.callPackageWith pkgs;
      workman = (callPackage ./workman {}).workman;
    in {
      font = "Lat2-Terminus16";
      keyMap = "us";
      packages =
        [ # pkgs.kbdKeymaps.dvp
          # pkgs.kbdKeymaps.neo
          workman # workman-p keyboard layout; see `services.xserver`
        ];
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

    variables = rec {
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
      VOLATILE_CONFIG = "/etc/nixos/volatile_config";
      VOLATILE_EXPORTS = "${CONFIG_ROOT}/.volatile_exports";
    };
  };

  environment.systemPackages =
    let
      # http://fontforge.github.io/en-US/documentation/utilities/
      # Tools include showttf, ttf2eps, pfadecrypt, pcl2ttf.
      fonttools = pkgs.fontforge-fonttools;
      easy-purescript-nix = import ./easy-purescript-nix { pkgs = pkgs; };
      purs-utils = easy-purescript-nix.inputs;
    in
      with pkgs; [
        exim getmail mutt notmuch-mutt procmail spamassassin # email services

        # xorg.xmodmap # https://wiki.xfce.org/faq
        # xorg.xev     # https://wiki.xfce.org/faq
        ag # silver-searcher
        atop # console system performance monitor
        # autossh # automatically restart SSH sessions and tunnels
        bat # a 'cat' clone with syntax highlighting and git integration
        bc # calculator
        # binutils # tools for manipulating binaries (linker, assembler
        broot # interactive tree view, fuzzy search, balanced BFS descent
        browsh # text-based browser that can render css and js (cf. links2, lynx, w3m)
        cabal-install # haskell packaging and build system
        cabal2nix # nix utility that transforms cabal specs into nix specs
        chromium # browser
        # conky # configurable X system monitor
        coq # interactive theorem prover
        ctags # utility for fast source-code browsing (exuberant ctags)
        darcs # version control system
        dragon-drop # Simple drag-and-drop source/sink for X
        # direnv # environment switcher for the shell
        docker # containerizer; OS-level virtualization: application container
        dotnet-sdk # .NET Core SDK 2.0.2 with .NET Core 2.0.0
        dotnetPackages.Nuget # .NET nuget
        dstat # monitor to replace vmstat, iostat, ifstat, netstat
        # ekiga # VOIP/video-conferencing app with full SIP and H.323 support
        elmPackages.elm # haskell-like frontend development platform
        exa # replacement for 'ls'
        expect # tool for automating interactive applications
        feh # light-weight image viewer
        ffmpeg # manager and converter of audio/vidoe files
        file # program that shows the type of files
        firefox-wrapper # browser
        fontforge-gtk # font editor with GTK UI
        fonttools
        fossil # version control system
        fzf # command-line fuzzy finder
        gitless # version control system built on top of git
        gdrive # command-line utility for interacting with google drive
        gnupg # GNU Privacy Guard, a GPL OpenPGP implementation
        golly # game of life
        haskellPackages.hakyll # static website compiler library
        heroku
        # hieroglyph # presentation editor
        # hlint
        htop # interactive process viewer
        hound # fast code searching (react frontend; go backend; regex w/ trigram index)
        idris # haskell-like compiler with dependent types
        # inkscape # vector-graphics editor # See https://castel.dev/post/lecture-notes-2/
        iotop
        irssi # terminal-based IRC client
        jitsi # open-source video calls and chat
        jq # command-line json processor
        kakoune # vim-inspired text editor
        libnotify # library that sends desktop notifications to a notification daemon
        libreoffice # open-source office suite
        librsvg # library to assist pandoc in rendering SVG images to Cairo surfaces
        # libtoxcore_0_2 # P2P FOSS instant-messaging application to replace Skype
        links2 # small browser with graphics support (`-g`) (cf. browsh, lynx, w3m)
        lsof # utility to list open files
        lynx # terminal web-browser (cf. browsh, links2, w3m)
        macchanger # utility for manipulating MAC addresses
        maim # cli screenshot utility
        # mitmproxy # man-in-the-middle proxy (recommended unix analogue for fiddler)
        mkpasswd # front-end for crypt (to make initial hashed pw: `mkpasswd -m sha-512`)
        # mopidy # extensible music server that plays music from local, Spotify, etc.
        mongodb # nosql database
        mtr # network-diagnostics tool
        mupdf # parsing engine for PDF, XPS, and EPUB
        myVim # text editor
        newsboat # fork of Newsbeuter, an RSS/Atom feed reader for the text console
        nix-bash-completions
        nix-diff # utility that compares nix derivations
        nixops # utility for provisioning NixOS machines
        nix-prefetch-git # nix utility that aids in pinning github revisions
        nnn # ncurses-based file manager/browser
        nodejs-10_x # javascript engine
        openvpn # tunneling application
        pandoc # utility that translates between markup formats
        pass # password-store manages passwords securely
        patchelf
        pavucontrol # PulseAudio volume control
        pijul # distributed version control system inspired by categorical patches
        powertop # utility to analyze power consumption on Intel-based laptops
        # privoxy # non-caching web proxy with advanced filtering capabilities
        # prover9 # automated theorem prover for first-order and eq logic
        psmisc # utilities using the proc file-system (fuser, killall, pstree, etc)
        purs-utils.dhall-simple
        purs-utils.dhall-json-simple
        purs-utils.psc-package
        purs-utils.psc-package2nix
        purs-utils.purp
        purs-utils.purs
        # purs-utils.purty
        purs-utils.spago
        purs-utils.spago2nix
        purs-utils.zephyr # purescript tree-shaker
        python36Packages.youtube-dl # command-line tool to download videos from video platforms
        (python39.withPackages (pkgs: [
          pkgs.beautifulsoup4 # html- and xml-parser
          #pkgs.fastapi # web/api framework
          #pkgs.flask # web/api microframework
          #pkgs.gensim # topic-modelling library
          #pkgs.huggingface-hub # interface with huggingface.co hub
          #pkgs.imbalanced-learn # manage imbalanced data
          pkgs.jupyter # web-based notebook environment for interactive computing
          #pkgs.jupyter_core # web-based notebook environment for interactive computing
          #pkgs.Keras # deep-learning library for Theano and TensorFlow
          pkgs.matplotlib # plotting library
          pkgs.networkx # network-management library
          pkgs.nltk # natural-language processing toolkit
          pkgs.numpy # scientific (num-processing) tools
          #pkgs.opencv4 # computer-vision library
          pkgs.pandas # python data-analysis library
          pkgs.pillow # fork of PIL (python imaging library)
          #pkgs.pytorch # deep-learning platform
          #pkgs.spacy # natural-language processing
          pkgs.scikit-learn # machine learning & data mining
          pkgs.scipy # science/engineering library
          pkgs.scrapy # web crawler and scraper
          pkgs.seaborn # statistical data visualization
          #pkgs.statsmodel # statistical modeling
          #pkgs.streamlit # build custom machine-learning tools
          pkgs.tensorflow # machine learning
          pkgs.xgboost # gradient boosting library (e.g., GBDTs)
          #pkgs.sklearn-deep # scikit-learn with evolutionary algorithms
        ])) # Cf nixos.wiki/wiki/Python
        qtox # Qt tox client
        qutebrowser # keyboard-focused browser with minimal GUI
        ranger # file manager
        renameutils # a set of programs to make renaming of files faster
        ripgrep # regex utility that's faster than the silver searcher ['rg']
        rofi # window switcher, run dialog and dmenu replacement
        rofi-pass # script to make rofi work with password-store
        rstudio
        rtv # reddit terminal client
        # rxvt_unicode # clone of rxvt (color vt102 terminal emulator)
        scrot # command-line screen-capture utility
        stack # haskell tool stack
        # stack2nix # nix utility that transforms stack specs into nix specs
        sysstat # performance-monitoring tools (sar, iostat, pidstat)
        tcpdump # network sniffer
        termite # keyboard-centric VTE-based terminal
        termonad-with-packages # terminal emulator configurable in haskell
        texlive.combined.scheme-full # pdflatex, xcolor.sty for PDF conversion
        # tig # text-mode interface for git
        # tinc # VPN daemon with full mesh routing
        tmux # terminal multiplexer
        tmuxp # manage tmux workspaces from JSON and YAML
        # tomb # file encryption
        # tor-browser-bundle-bin # tor browser
        translate-shell # command-line translator
        tree # commandline directory visualizer
        units # unit-conversion tool
        usbutils # tools (e.g., lsusb) for working with USB devices
        utox # (mu-tox) lightweight tox client

        # Currently, see ~/.vintrc.yaml for theo-wide vint configuration.
        vim-vint # vimscript linting tool by !gh/kuniwak/vint (in vim and at cli)

        virtualbox # hosted hypervisor (hardware virtualization); virtual-machine manager
        vlc # cross-platform media player and streaming server
        w3m # text-based web browser (cf. browsh, links2, lynx)
        # wordgrinder # terminal-based word processor
        xclip # clipboard utility
        xdotool # fake keyboard/mouse input, window management
        yarn # variant to npm
        # yi # yi text editor (written in haskell)
        zathura # PDF reader with vim bindings; plugin-based document viewer; can use mupdf as plugin
        zeal # offline API documentation browser
        zim # desktop wiki
      ];

  environment.theo = {
    programs = {
      bookmark.enable = true;
      execute-namespace.enable = true;
      git.enable = true;
      rofi.enable = true;
    };
    services = {
      automatic-mac-spoofing.enable = false;
      i3.enable = true;
    };
  };

  i18n = {
      defaultLocale = "en_US.UTF-8";
    };

  networking.hostName = "theo"; # Define your hostname.
  networking.networkmanager.enable = true;

  nix.gc = {
    automatic = true;
    dates = "Sun 03:15";
  };

  nixpkgs.config = {
    allowUnfree = true;
    # chromium.enableWideVine = true;
    packageOverrides = pkgs: {
      myVim = import ./vim { pkgs = pkgs; };
    };
  };

  fonts = {
    fontDir.enable = true;
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
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        b = "cd ..";
        b1 = "cd ..";
        b2 = "cd ../..";
        b3 = "cd ../../..";
        b4 = "cd ../../../..";
        b5 = "cd ../../../../..";
        cat = "cat -A"; # So that scripts don't abuse carriage-return.
        gco = "git co";
        gcob = "git cob";
        gd = "git diff";
        gdiff = "git diff";
        gits = "git s";
        gitst = "git st";
        gs = "git status";
        gst = "git st";
        ixclip = "xclip -i -sel clip";
        l = "ls -Alh --color=tty";
        l1 = "ls -1A --color=tty --group-directories-first";
        ls = "ls -A --color=tty --group-directories-first";
        lsm = "lsmark";
        oxclip = "xclip -o -sel clip";
        promptToggle = "togglePrompt";
        quit = "exit";
        rm = "rm -I";
        stackBuild = "NIX_PATH=$NIXOS_UNSTABLE_NIX_PATH stack build --nix --fast";
        startStackShell = "NIX_PATH=$NIXOS_UNSTABLE_NIX_PATH nix-shell -p stack";
        touchpadToggle = "toggleTouchpad";
        v = "vim";
        vimNoSpell = "vim -c 'set nospell'";
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
  };

  services.mongodb.enable = false;
  services.openssh.enable = true;

  services.xserver = {
    enable = true;
    displayManager = {
      defaultSession = "none+i3";
      sessionCommands = ''
        ${pkgs.xlibs.xrdb}/bin/xrdb -load ${./graphical/Xresources} &
      '';
    };
    layout = "us";
    synaptics.enable = true; # touchpad
    xkbModel = "pc104";
    xkbOptions = "ctrl:nocaps";
    xkbVariant = "";
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
