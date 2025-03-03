# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
      # http://fontforge.github.io/en-US/documentation/utilities/
      # Tools include showttf, ttf2eps, pfadecrypt, pcl2ttf.
      fonttools = pkgs.fontforge-fonttools;
    in
      with pkgs; [
        # Reconsider:
        # borgmatic # configuration-driven backup software
        difftastic # syntax-aware diff
        expect # tool for automating interactive applications
        # neofetch # fastfetch # neofetch-like system-information tool
        ffuf # fast web fuzzer
        file # program that shows the type of files
        koreader # ebook-reader application
        lean4 # automatic and interactive theorem prover
        lorri # your project's nix-env
        manim # animation engine for explanatory mathematics videos
        # manim-slides # tool for live presenations using manim
        niv # dependency manager for nix projects
        nmap # utitlity for network discovery and security auditing
        nushell # shell inspired by powershell written in rust
        openssh # implementation of the SSH protocol
        parallel # shell tool fro executing jobs in parallel [cf. xargs ?]
        pass # password-store manages passwords securely
        renameutils # a set of programs to make renaming of files faster
        rstudio

        atop # console system performance monitor
        # autofs5 # kernel-based automounter
        bat # a 'cat' clone with syntax highlighting and git integration
        bat-extras.batdiff # integration of bat and diff
        bat-extras.batgrep # integration of bat and ripgrep
        bat-extras.batman # integration of bat and man
        bat-extras.prettybat
        bc # calculator
        bfs # breadth-first version of 'find'
        broot # interactive tree view, fuzzy search, balanced BFS descent
        browsh # text-based browser that can render css and js (cf. links2, lynx, w3m)
        burpsuite # integrated platform for performing security testing
        cabal-install # haskell packaging and build system
        cabal2nix # nix utility that transforms cabal specs into nix specs
        calibre # e-book software (calibredb, ebook-convert, ebook-viewer, etc.)
        chromium # browser
        cifs-utils # tools for managing CIFS client filesystems (CIFS is Microsoft's version of SMB)
        cmatrix # simulates the falling characters theme from 'The Matrix' movie
        conky # system monitor based on torsmo
        coq_8_9 # coq theorem assistant
        ctags # utility for fast source-code browsing (exuberant ctags)
        ddgr # search DuckDuckGo from the terminal
        dstat # monitor to replace vmstat, iostat, ifstat, netstat
        dua # tool to learn about directories' disk usage
        du-dust # du + rust = dust; like du but more intuitive
        duf # disk usage / free utility ('du' substitute)
        eza # replacement for 'ls'
        fd # alternative to 'find'
        feh # light-weight image viewer
        ffmpeg # manager and converter of audio/video files
        firefox
        # firefox-wrapper # browser
        # latest.firefox-nightly-bin
        fontforge-gtk # font editor with GTK UI
        fonttools
        fzf # command-line fuzzy finder
        gimp # GNU image-manipulation program
        gdrive # command-line utility for interacting with google drive
        ghostscript # PostScript interpreter
        glances # curses-bases monitoring tool (cf. htop)
        gnupg # GNU Privacy Guard, a GPL OpenPGP implementation
        htop # interactive process viewer
        hound # fast code searching (react frontend; go backend; regex w/ trigram index)
        iotop
        iperf3 # tool to measure IP/UDP & IP/TCP bandwith
        jq # command-line json processor
        jqp # TUI playground for experimenting with jq
        lazygit # simple terminal UI for git commands
        libnotify # library that sends desktop notifications to a notification daemon
        libreoffice # open-source office suite
        librewolf # fork of Firefox, focused on privacy and security
        librsvg # library to assist pandoc in rendering SVG images to Cairo surfaces
        links2 # small browser with graphics support (`-g`) (cf. browsh, lynx, w3m)
        lsof # utility to list open files
        lynx # terminal web-browser (cf. browsh, links2, w3m)
        macchanger # utility for manipulating MAC addresses
        maim # cli screenshot utility [cf. scrot]
        mkpasswd # front-end for crypt (to make initial hashed pw: `mkpasswd -m sha-512`)
        mmv # utility for wildcard renaming, copying, etc
        mtr # network-diagnostics tool
        mupdf # parsing engine for PDF, XPS, and EPUB
        myVim # text editor
        neovim # text editor
        # newsboat # terminal RSS/Atom-feed reader
        # nom # terminal RSS-feed reader
        nix-bash-completions
        nix-diff # utility that compares nix derivations
        nix-prefetch-git # nix utility that aids in pinning github revisions
        nodejs_20 # nodejs-17_x -> ?? # javascript engine
        openssl # cryptographic library that implements TSL protocol
        openvpn # tunneling application
        pandoc # utility that translates between markup formats
        patchelf
        pavucontrol # PulseAudio volume control
        pciutils # programs (like 'lspci') for managing PCI devices
        poppler_utils # PDF tools like pdfunite and pdfseparate
        powertop # utility to analyze power consumption on Intel-based laptops
        psmisc # utilities using the proc file-system (fuser, killall, pstree, etc)
        (python310.withPackages (pkgs:
          [
            pkgs.arxiv2bib # get a BibTeX entry from an arXiv id number
            pkgs.beautifulsoup4 # html- and xml-parser
            # pkgs.bokeh # statistical and interactive HTML plots
            # pkgs.ipdb # web-based notebook environment for interactive computing
            # pkgs.ipython # web-based notebook environment for interactive computing
            # pkgs.jupyter # web-based notebook environment for interactive computing
            # pkgs.keras # deep-learning library for Theano and TensorFlow
            # pkgs.matplotlib # plotting library
            # pkgs.networkx # network-management library
            # pkgs.nltk # natural-language processing toolkit
            pkgs.numpy # scientific (num-processing) tools
            # pkgs.opencv4 # Open Computer Vision library
            # pkgs.openpyxl # read/write Excel 2007 xlsx/xlsm files
            # pkgs.pandas # python data-analysis library
            # pkgs.pdfminer # PDF parser and analyzer
            # pkgs.pikepdf # qpdf-utility to create/manipulate/repair PDFs
            # pkgs.pilkit # utilities for python imaging library
            # pkgs.pillow # fork of PIL (python imaging library)
            # pkgs.pypdf
            # pkgs.pypdf2
            # pkgs.pypdf3
            # pkgs.pytorch # deep-learning platform
            # pkgs.requests_toolbelt
            # pkgs.scikit-learn # machine learning & data mining
            pkgs.scrapy # web crawler and scraper
            # pkgs.seaborn # statistical data visualization
            # pkgs.tensorflow-bin # machine learning
            # pkgs.tkinter
            # pkgs.torchvision # deep-learning platform                             # *
          ]
        ))
        qpdf # C++ programs that inspect/manipulate PDF files
        qutebrowser # keyboard-focused browser
        ripgrep # regex utility that's faster than the silver searcher ['rg']
        ripgrep-all # search utility for PDFs, e-books, office docs, zip, targ.gz, etc.
        rofi # window switcher, run dialog and dmenu replacement
        rofi-pass # script to make rofi work with password-store
        sageWithDoc # open-source alternative to magma maple, mathematica, and matlab
        scrot # command-line screen-capture utility [cf. maim]
        signal-desktop # signal messenger
        silver-searcher # ag -> silver-searcher # silver-searcher
        sl # steam Locomotive runs across your terminal
        sqldiff # SQLite-db differ
        sqlite # self-contained SQL database engine
        sqlite-utils # CLI utility and library for manipulating SQLite databases
        stack # haskell tool stack
        sysstat # performance-monitoring tools (sar, iostat, pidstat)
        texmaker # Tex and LaTex editor
        tex-match # desktop version of detexify: search by sketching
        texstudio # Tex and LaTex editor
        tcpdump # network sniffer
        termite # keyboard-centric VTE-based terminal
        termonad # termonad-with-packages -> termonad # terminal emulator configurable in haskell
        texlive.combined.scheme-full # pdflatex, xcolor.sty for PDF conversion
        tig # text-mode interface for git
        # timeshift # system-restore tool [cf. snapper]
        tldr # community-managed man pages
        tmux # terminal multiplexer
        tmuxp # manage tmux workspaces from JSON and YAML
        translate-shell # command-line translator
        tree # commandline directory visualizer
        typst # markup-based typesetting system
        units # unit-conversion tool
        unzip # extraction utility for archives cmopressed in .zip format
        usbutils # tools (e.g., lsusb) for working with USB devices
        vim-vint # vimscript linting tool by !gh/kuniwak/vint (in vim and at cli)
        vlc # cross-platform media player and streaming server
        w3m # text-based web browser (cf. browsh, links2, lynx)
        wget # tool for retrieving files using HTTP, HTTPS, and FTP
        wireshark-cli # network-protocol analyzer
        xclip # clipboard utility
        xdotool # fake keyboard/mouse input, window management
        yazi # terminal file manager
        yq-go # cli YAML processor
        yt-dlp # command-line tool to download videos from video platforms
        xdragon # Simple drag-and-drop source/sink for X
        zathura # PDF reader with vim bindings; plugin-based document viewer; can use mupdf as plugin
        zip # compressor/achiver for creating and modifyig zipfiles
      ];

  environment.theo = {
    programs = {
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
      # permittedInsecurePackages =
      #   [
      #     "nodejs-14.21.3"
      #     "openssl-1.1.1u"
      #     "python-2.7.18.6"
      #     "python2.7-certifi-2021.10.8"
      #     "python2.7-pyjwt-1.7.1"
      #   ];
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
        l = "ls -Alh --color=tty";
        l1 = "ls -1A --color=tty --group-directories-first";
        ls = "ls -A --color=tty --group-directories-first";
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
    printing = {
      enable = true;
      browsing = true;
      drivers =
        with pkgs; [
          gutenprint
          hplip
          postscript-lexmark
          brlaser
        ];
      # Note: With this present configuration, CUPS doesn't recognized IPv4,
      # so a 'Bad Request' response is given to any request to http://localhost:631/.
      # IPv6, however, is acceptable, so Navigate to http://[::1]:631/.
      listenAddresses = [ "*:631" ];
      defaultShared = true;
    };
    openssh.enable = true;
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
