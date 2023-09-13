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
      ./format-purs-json-errors-output
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

    variables =
      let
        eb-smtp-config = (import /etc/nixos/volatile_config/eb_display {}).smtp;
      in rec {
        BOOKMARKPATH = "${CONFIG_ROOT}/bookmarks";
        CONFIG_ROOT = "${VOLATILE_CONFIG}/$USER";
        EB_SMTP_PASSWORD = eb-smtp-config.password;
        EB_SMTP_PORT = eb-smtp-config.port;
        EB_SMTP_URL = eb-smtp-config.url;
        EB_SMTP_USER = eb-smtp-config.user;
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
      # magma_cudatoolkit_11_4 = pkgs.magma.override { cudatoolkit = pkgs.cudatoolkit_11_4; };

      # http://fontforge.github.io/en-US/documentation/utilities/
      # Tools include showttf, ttf2eps, pfadecrypt, pcl2ttf.
      fonttools = pkgs.fontforge-fonttools;

      easy-purescript-nix = import ./easy-purescript-nix { pkgs = pkgs; };
      purs-utils = easy-purescript-nix.inputs;

      # python-ghostscript =
      #   let
      #     callPackage = pkgs.lib.callPackageWith pkgs;
      #     python311 = pkgs.python311;
      #     python311Pkgs = python311.pkgs;
      #     substituteAll = pkgs.substituteAll;
      #   in
      #     callPackage (import ./python-modules/python-ghostscript) {
      #       buildPythonPackage = python311Pkgs.buildPythonPackage;
      #       ghostscript = pkgs.ghostscript;
      #       isPy3k = python311.passthru.isPy3k;
      #       substituteAll = substituteAll;
      #     };

      # camelot =
      #   let
      #     callPackage = pkgs.lib.callPackageWith pkgs;
      #     python311 = pkgs.python311;
      #     python311Pkgs = python311.pkgs;
      #   in
      #     callPackage (import ./python-modules/camelot) {
      #       buildPythonPackage = python311Pkgs.buildPythonPackage;
      #       chardet = python311Pkgs.chardet;
      #       click = python311Pkgs.click;
      #       ghostscript = pkgs.ghostscript;
      #       isPy3k = python311.passthru.isPy3k;
      #       numpy = python311Pkgs.numpy;
      #       cv2 = python311Pkgs.opencv4;
      #       openpyxl = python311Pkgs.openpyxl;
      #       pandas = python311Pkgs.pandas;
      #       pdfminer_six = python311Pkgs.pdfminer;
      #       pypdf = python311Pkgs.pypdf;
      #       python-ghostscript = python-ghostscript;
      #       tabulate = python311Pkgs.tabulate;
      #       tkinter = python311Pkgs.tkinter;
      #     };

    in
      with pkgs; [
        # email services
        exim
        getmail6 # getmail -> getmail6
        mutt
        notmuch-mutt
        procmail
        spamassassin

        mailsend # CLI email-sending tool
        mailutils # protocol-independent mail framework (includes mailx)

        # cudatoolkit_11_4
        # cudnn_cudatoolkit_11_4

        # Reconsider:
        agda # dependently typed functional language and proof assistant
        # autossh # automatically restart SSH sessions and tunnels
        bun # javascript runtime, bundler, transpiler, and package manager
        # binutils # tools for manipulating binaries (linker, assembler)
        # btrfs-progs # utilities for the btrfs filesystem
        burpsuite # integrated platform for performing security testing
        # conky # configurable X system monitor
        # coq # interactive theorem prover
        coq_8_9 # coq theorem assistant
        # darcs # version control system
        deno # secure runtime for javascript and typescript
        difftastic # syntax-aware diff
        # direnv # environment switcher for the shell
        # docker # containerizer; OS-level virtualization: application container
        # dotnet-sdk # .NET Core SDK 2.0.2 with .NET Core 2.0.0
        # dotnetPackages.Nuget # .NET nuget
        xdragon # dragon-drop -> xdragon # Simple drag-and-drop source/sink for X
        # ekiga # VOIP/video-conferencing app with full SIP and H.323 support
        # elmPackages.elm # haskell-like frontend development platform
        expect # tool for automating interactive applications
        ffuf # fast web fuzzer
        file # program that shows the type of files
        # fossil # version control system
        # gitless # version control system built on top of git [Its cli abbrev is 'gl'.]
        # golly # game of life
        # haskellPackages.hakyll # static website compiler library
        # helix # post-modern modal text editor
        # heroku
        # hieroglyph # presentation editor
        # hlint
        idris # haskell-like compiler with dependent types
        # inkscape # vector-graphics editor # See https://castel.dev/post/lecture-notes-2/
        # irssi # terminal-based IRC client
        # jitsi # open-source video calls and chat
        # kakoune # vim-inspired text editor
        # kakounePlugins.active-window-kak
        # # kakounePlugins.active-pairs-kak
        # kakounePlugins.case-kak
        # kakounePlugins.fzf-kak
        # kakounePlugins.kak-lsp
        # kakounePlugins.kakoune-easymotion
        # kakounePlugins.kakoune-rainbow
        # kakounePlugins.kakoune-registers
        # kakounePlugins.kakoune-vertical-selection
        # kakounePlugins.pandoc-kak
        # kakounePlugins.smarttab-kak
        # kakounePlugins.tabs-kak
        lean3 # automatic and interactive theorem prover
        # libgnome_keyring # framework for managing passwords and other secrets
        # libtoxcore_0_2 # P2P FOSS instant-messaging application to replace Skype
        lorri # your project's nix-env
        # magma_cudatoolkit_11_4 # matrix algebra on GPU and multicore architecture
        # manim # animation engine for explanatory mathematics videos
        # mcfly # bash-history-management tool
        # mitmproxy # man-in-the-middle proxy (recommended unix analogue for fiddler)
        # mopidy # extensible music server that plays music from local, Spotify, etc.
        # mongodb # nosql database
        # networkmanager_openconnect # NetworkManager's OpenConnect plugin
        # newsboat # fork of Newsbeuter, an RSS/Atom feed reader for the text console
        niv # dependency manager for nix projects
        # nnn # ncurses-based file manager/browser
        nushell # shell inspired by powershell written in rust
        # okular # unlike zathura, it has pdf-annotating and -highlighting features
        # openconnect # VPN client for Cisco's AnyConnect SSL VPN
        # opencv2 # Open Computer Vision library
        openssh # implementation of the SSH protocol
        parallel # shell tool fro executing jobs in parallel [cf. xargs ?]
        pass # password-store manages passwords securely
        # pijul # distributed version control system inspired by categorical patches
        # privoxy # non-caching web proxy with advanced filtering capabilities
        # prover9 # automated theorem prover for first-order and eq logic
        # qpdfview # tabbed (PDF) document viewer
        # qtox # Qt tox client
        # ranger # file manager
        renameutils # a set of programs to make renaming of files faster
        # rstudio
        # rtv # reddit terminal client # Consider using 'tuir'.
        # rxvt_unicode # clone of rxvt (color vt102 terminal emulator)
        # rxvt-unicode-plugins.font-size # New name for 'urxvt_font_size'
        # sc-im # ncurses spreadsheet for terminal
        # sqldiff # SQLite-db differ
        # sqlite # self-contained ZQL database engine
        # sqlite-analyzer # stats tool for SQLite databases
        # stack2nix # nix utility that transforms stack specs into nix specs
        # tinc # VPN daemon with full mesh routing
        # tomb # file encryption
        # tor-browser-bundle-bin # tor browser
        utox # (mu-tox) lightweight tox client
        virtualbox # hosted hypervisor (hardware virtualization); virtual-machine manager
        # wordgrinder # terminal-based word processor
        # yi # yi text editor (written in haskell)
        # zeal # offline API documentation browser
        # zim # desktop wiki

        # xorg.xmodmap # https://wiki.xfce.org/faq
        # xorg.xev     # https://wiki.xfce.org/faq

        atop # console system performance monitor
        bat # a 'cat' clone with syntax highlighting and git integration
        bat-extras.batdiff # integration of bat and diff
        bat-extras.batgrep # integration of bat and ripgrep
        bat-extras.batman # integration of bat and man
        bat-extras.prettybat
        bc # calculator
        bfs # breadth-first version of 'find'
        broot # interactive tree view, fuzzy search, balanced BFS descent
        browsh # text-based browser that can render css and js (cf. links2, lynx, w3m)
        cabal-install # haskell packaging and build system
        cabal2nix # nix utility that transforms cabal specs into nix specs
        chromium # browser
        cifs-utils # tools for managing CIFS client filesystems (CIFS is Microsoft's version of SMB)
        ctags # utility for fast source-code browsing (exuberant ctags)
        dstat # monitor to replace vmstat, iostat, ifstat, netstat
        dua # tool to learn about directories' disk usage
        du-dust # du + rust = dust; like du but more intuitive
        duf # disk usage / free utility ('du' substitute)
        exa # replacement for 'ls'
        fd # alternative to 'find'
        feh # light-weight image viewer
        ffmpeg # manager and converter of audio/video files
        # firefox-wrapper # browser
        latest.firefox-nightly-bin
        fontforge-gtk # font editor with GTK UI
        fonttools
        fzf # command-line fuzzy finder
        gimp # GNU image-manipulation program
        gdrive # command-line utility for interacting with google drive
        ghostscript # PostScript interpreter
        gnupg # GNU Privacy Guard, a GPL OpenPGP implementation
        htop # interactive process viewer
        hound # fast code searching (react frontend; go backend; regex w/ trigram index)
        iotop
        jq # command-line json processor
        lazygit # simple terminal UI for git commands
        libnotify # library that sends desktop notifications to a notification daemon
        libreoffice # open-source office suite
        # libreswan # open-source IPSec-based VPN implementation
        librsvg # library to assist pandoc in rendering SVG images to Cairo surfaces
        links2 # small browser with graphics support (`-g`) (cf. browsh, lynx, w3m)
        lsof # utility to list open files
        lynx # terminal web-browser (cf. browsh, links2, w3m)
        macchanger # utility for manipulating MAC addresses
        maim # cli screenshot utility [cf. scrot]
        mkpasswd # front-end for crypt (to make initial hashed pw: `mkpasswd -m sha-512`)
        mtr # network-diagnostics tool
        mupdf # parsing engine for PDF, XPS, and EPUB
        myVim # text editor
        neovim # text editor
        # networkmanager_strongswan # Network Manager's strongswan plugin
        nix-bash-completions
        nix-diff # utility that compares nix derivations
        nixops # utility for provisioning NixOS machines
        nix-prefetch-git # nix utility that aids in pinning github revisions
        nodejs_20 # nodejs-17_x -> ?? # javascript engine
        oil # unix shell
        openssl # cryptographic library that implements TSL protocol
        openvpn # tunneling application
        pandoc # utility that translates between markup formats
        patchelf
        pavucontrol # PulseAudio volume control
        pciutils # programs (like 'lspci') for managing PCI devices
        poppler_utils # PDF tools like pdfunite and pdfseparate
        powertop # utility to analyze power consumption on Intel-based laptops
        psmisc # utilities using the proc file-system (fuser, killall, pstree, etc)
        purs-utils.dhall-json-simple
        purs-utils.dhall-simple
        purs-utils.psa
        purs-utils.psc-package
        purs-utils.psc-package2nix
        purs-utils.pscid
        purs-utils.pulp-16_0_2
        purs-utils.purescript-language-server
        # purs-utils.purp
        purs-utils.purs-0_15_8
        purs-utils.purs-backend-es-1_1_0
        purs-utils.purs-tidy
        purs-utils.purty
        purs-utils.spago
        purs-utils.spago2nix
        purs-utils.zephyr # purescript tree-shaker
        (python311.withPackages (pkgs:
          # let
          #   pytorch = pkgs.pytorch.override {
          #     # cudaSupport = true;
          #     cudaSupport = false;
          #     # cudatoolkit = cudatoolkit_11_4;
          #     # cudnn = cudnn_cudatoolkit_11_4;
          #     # magma = magma_cudatoolkit_11_4;
          #   };
          #   torchvision = pkgs.torchvision.override { pytorch = pytorch; };
          # in [
          [
            pkgs.arxiv2bib # get a BibTeX entry from an arXiv id number
            pkgs.beautifulsoup4 # html- and xml-parser
            # pkgs.bokeh # statistical and interactive HTML plots
            # camelot
            # pkgs.fastapi # web/api framework
            # pkgs.flask # web/api microframework
            # pkgs.gensim # topic-modelling library
            # pkgs.huggingface-hub # interface with huggingface.co hub
            # pkgs.imbalanced-learn # manage imbalanced data
            pkgs.ipdb # web-based notebook environment for interactive computing
            pkgs.ipython # web-based notebook environment for interactive computing
            # 23.05 can't build. # pkgs.jupyter # web-based notebook environment for interactive computing
            # pkgs.jupyter_core # web-based notebook environment for interactive computing
            # pkgs.Keras # deep-learning library for Theano and TensorFlow
            pkgs.matplotlib # plotting library
            pkgs.networkx # network-management library
            # pkgs.nltk # natural-language processing toolkit
            pkgs.numpy # scientific (num-processing) tools
            # pkgs.openai # client library for the OpenAI API
            pkgs.opencv4 # Open Computer Vision library
            pkgs.openpyxl # read/write Excel 2007 xlsx/xlsm files
            pkgs.pandas # python data-analysis library
            pkgs.pdfminer # PDF parser and analyzer
            pkgs.pikepdf # qpdf-utility to create/manipulate/repair PDFs
            pkgs.pilkit # utilities for python imaging library
            pkgs.pillow # fork of PIL (python imaging library)
            pkgs.pypdf
            pkgs.pypdf2
            pkgs.pypdf3
            #pkgs.pytorchWithCuda # deep-learning platform
            # python-ghostscript
            # pytorch # deep-learning platform
            pkgs.requests_toolbelt
            # pkgs.spacy # natural-language processing
            # pkgs.scikit-learn # machine learning & data mining
            # pkgs.scipy # science/engineering library
            pkgs.scrapy # web crawler and scraper
            # pkgs.seaborn # statistical data visualization
            # pkgs.statsmodel # statistical modeling
            # pkgs.streamlit # build custom machine-learning tools
            # pkgs.tensorflow # machine learning
            # pkgs.torch
            # pkgs.torchaudio
            # pkgs.torchvision # deep-learning platform
            # pkgs.unittest2 # backport of unittest testing framework
            # pkgs.xgboost # gradient boosting library (e.g., GBDTs)
            # pkgs.sklearn-deep # scikit-learn with evolutionary algorithms
          ]
        )) # Cf nixos.wiki/wiki/Python
        qpdf # C++ programs that inspect/manipulate PDF files
        qutebrowser # keyboard-focused browser with minimal GUI
        ripgrep # regex utility that's faster than the silver searcher ['rg']
        rofi # window switcher, run dialog and dmenu replacement
        rofi-pass # script to make rofi work with password-store
        scrot # command-line screen-capture utility [cf. maim]
        silver-searcher # ag -> silver-searcher # silver-searcher
        stack # haskell tool stack
        # strongswan # open-source IPsec-based VPN solution
        sysstat # performance-monitoring tools (sar, iostat, pidstat)
        tcpdump # network sniffer
        termite # keyboard-centric VTE-based terminal
        termonad # termonad-with-packages -> termonad # terminal emulator configurable in haskell
        texlive.combined.scheme-full # pdflatex, xcolor.sty for PDF conversion
        tig # text-mode interface for git
        tldr # community-managed man pages
        tmux # terminal multiplexer
        tmuxp # manage tmux workspaces from JSON and YAML
        translate-shell # command-line translator
        tree # commandline directory visualizer
        units # unit-conversion tool
        unzip # extraction utility for archives cmopressed in .zip format
        usbutils # tools (e.g., lsusb) for working with USB devices
        # Currently, see ~/.vintrc.yaml for theo-wide vint configuration.
        vim-vint # vimscript linting tool by !gh/kuniwak/vint (in vim and at cli)
        vlc # cross-platform media player and streaming server
        w3m # text-based web browser (cf. browsh, links2, lynx)
        wget # tool for retrieving files using HTTP, HTTPS, and FTP
        xclip # clipboard utility
        xdotool # fake keyboard/mouse input, window management
        yarn # variant to npm
        youtube-dl # command-line tool to download videos from video platforms
        yq-go # cli YAML processor
        yt-dlp # command-line tool to download videos from video platforms
        zathura # PDF reader with vim bindings; plugin-based document viewer; can use mupdf as plugin
        zip # compressor/achiver for creating and modifyig zipfiles
      ];

  environment.theo = {
    programs = {
      bookmark.enable = true;
      execute-namespace.enable = true;
      format-purs-json-errors-output.enable = true;
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

  networking = {
    firewall = {
      allowedUDPPorts = [ 631 ];
      allowedTCPPorts = [ 631 3000 ];
      # extraCommands = ''
      #     iptables -A OUTPUT -o wlo1 -p tcp --sport 3000 -m state --state ESTABLISHED -j ACCEPT
      #   '';
    };
    hostName = "theo"; # Define your hostname.
    networkmanager.enable = true;
  };

  nix = {
    gc = {
      automatic = true;
      dates = "Sun 03:15";
    };
    # package = pkgs.nixUnstable;
    extraOptions = ''
        experimental-features = nix-command flakes
      '';
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      # chromium.enableWideVine = true;
      cudaSupport = true;
      packageOverrides = pkgs: {
        myVim = import ./vim { pkgs = pkgs; };
      };
      permittedInsecurePackages =
        [
          "nodejs-14.21.3"
          "openssl-1.1.1u"
          "python-2.7.18.6"
          "python2.7-certifi-2021.10.8"
          "python2.7-pyjwt-1.7.1"
          # "python2.7-PyJWT-1.7.1"
          # "python2.7-urllib3-1.26.2"
        ];
    };
    overlays =
      let
        # Change the following to a rev/sha to pin.
        mozRev = "master";
        mozUrl = builtins.fetchTarball {
          url = "https://github.com/mozilla/nixpkgs-mozilla/archive/${mozRev}.tar.gz";
        };
        nightlyOverlay = (import "${mozUrl}/firefox-overlay.nix");
      in [ nightlyOverlay ];
  };

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    fonts =
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
        dsall = "sall2 --dry-run";
        dsall2 = "sall2 --dry-run";
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
        openen = "openeb";
        oxclip = "xclip -o -sel clip";
        promptToggle = "togglePrompt";
        quit = "exit";
        rm = "rm -I";
        sall = "sall2";
        sb = "spago-build-json";
        sbp = "spago-build-json-pretty";
        spago-build-json = "spago -q build --purs-args --no-prefix --purs-args --json-errors";
        spago-build-json-pretty = "spago -q build --purs-args --no-prefix --purs-args --json-errors 2>&1 | grep -v Compiling | format-purs-json-errors-output";
        stackBuild = "NIX_PATH=$NIXOS_UNSTABLE_NIX_PATH stack build --nix --fast";
        startStackShell = "NIX_PATH=$NIXOS_UNSTABLE_NIX_PATH nix-shell -p stack";
        touchpadToggle = "toggleTouchpad";
        v = "vim";
        worto = "vim $MARKPATH/expl/wortolisto";
        zpdf = "/home/polytope/eb-bin/zopen";
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

    # Printing
    avahi = {
      enable = true;
      publish.enable = true;
      publish.userServices = true;
      nssmdns = true;
    };
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

    # gnome.gnome-keyring.enable = true;
    # mongodb.enable = true;
    openssh.enable = true;

    # strongswan = {
    #   enable = true;
    #   secrets = {
    #     "user" = {
    #       secret = "/run/keys/vpn-password";
    #       id = "%any";
    #       ip = "%any";
    #     };
    #   };
    #   connections = {
    #     myvpn = {
    #       keyExchange = "ikev2";
    #       localAddress = "192.0.2.100";
    #       remoteAddress = "203.0.113.0";
    #       localId = "alice@strongswan.org";
    #       remoteId = "bob@strongswan.org";
    #       autoStart = "start";
    #       ipsec = {
    #         esp = "aes128gcm16-modp2048";
    #         ike = "aes128gcm16-modp2048";
    #         rekey = "no";
    #         reqid = "1";
    #         keyingtries = "3";
    #       };
    #       ikev2 = {
    #         dpdaction = "clear";
    #         proposals = "aes128-sha256-ecp256,aes256-sha384-ecp384,aes128-sha256-modp2048,aes128-sha1-modp2048,aes256-sha384-modp4096,aes256-sha256-modp4096,aes256-sha1-modp4096,aes128-sha256-modp1536,aes128-sha1-modp1536,aes256-sha384-modp2048,aes256-sha256-modp2048,aes256-sha1-modp2048,3des-sha1-modp1024";
    #         reauth = "no";
    #       };
    #     };
    #   };
    # };

    # xlibs -> xorg
    xserver = {
      enable = true;
      displayManager = {
        defaultSession = "none+i3";
        sessionCommands = ''
          ${pkgs.xorg.xrdb}/bin/xrdb -load ${./graphical/Xresources} &
        '';
      };
      layout = "us";

      # # https://old.reddit.com/r/NixOS/comments/5pz17o/getting_a_touchpad_working_on_a_laptop/
      # libinput = {
      #   enable = true;
      #   touchpad = {
      #     middleEmulation = true;
      #     naturalScrolling = false;
      #     tapping = true;
      #   };
      # };
      # # libinput.enable = true; # !gh NixOS nixpkgs issue 170489
      # # NOTE: `libinput` and `synaptics` are incompatible.
      # # synaptics.enable = true; # touchpad
      # ----
      # ----
      # synaptics.enable = true; # touchpad
      # ----
      # ----
      libinput.enable = true;

      # videoDrivers = [ "nvidia" ];
      xkbModel = "pc104";
      xkbOptions = "ctrl:nocaps";
      xkbVariant = "";
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
