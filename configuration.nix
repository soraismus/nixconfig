# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./git
      ./i3
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "theo"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   # consoleKeyMap = "dvorak";
  #   defaultLocale = "en_US.UTF-8";
  # };

  time.timeZone = "America/New_York";

  nixpkgs.config = {
    packageOverrides = pkgs: {
      myVim = import ./vim { pkgs = pkgs; };
    };
  };

  environment.theo.programs.git.enable = true;
  environment.theo.services.i3.enable = true;

  # bash and inputrc # see also line 166
  environment.interactiveShellInit = pkgs.lib.concatStringsSep "\n" [
    (builtins.readFile ./bash/functions)
    (builtins.readFile ./bash/settings)
    (builtins.readFile ./bash/variables)
    (builtins.readFile ./bash/direnv-hook)
  ];
  environment.etc."inputrc".source = ./bash/inputrc;

  # environment.sessionVariables = {
    # BROWSER = "qtb";
    # TERM = "xterm";
    # TERM = "xterm-256color";
    # TERM = "rxvt-unicode";
    # EMAIL = "anonymous@example.com";
    # PAGER = "less";
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # xorg.xmodmap # https://wiki.xfce.org/faq
    # xorg.xev     # https://wiki.xfce.org/faq
    ag # silver-searcher
    # autossh # automatically restart SSH sessions and tunnels
    bc # calculator
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
    elmPackages.elm # haskell-like frontend development platform
    feh # light-weight image viewer
    # fira-code-symbols # FiraCode unicode ligature glyphs in private use area
    firefox-wrapper # browser
    # fontforge # font editor
    fzf # command-line fuzzy finder
    gnupg # GNU Privacy Guard, a GPL OpenPGP implementation
    gdrive # command-line utility for interacting with google drive
    haskellPackages.hakyll # static website compiler library
    heroku
    # hlint
    htop # interactive process viewer
    # hound # fast code searching (symbolhound.com?)
    idris # haskell-like compiler with dependent types
    # inkscape # vector-graphics editor
    iotop
    irssi # terminal-based IRC client
    jq # command-line json processor
    libnotify # library that sends desktop notifications to a notification daemon
    libreoffice # open-source office suite
    lsof # utility to list open files
    lynx # terminal web-browser
    # mitmproxy # man-in-the-middle proxy (recommended unix analogue for fiddler)
    mkpasswd # front-end for crypt (to make initial hashed pw: `mkpasswd -m sha-512`)
    # mopidy # extensible music server that plays music from local, Spotify, etc.
    mupdf # parsing engine for PDF, XPS, and EPUB
    # newsboat # fork of Newsbeuter, an RSS/Atom feed reader for the text console
    nix-bash-completions
    nixops # utility for provisioning NixOS machines
    nix-prefetch-git # nix utility that aids in pinning github revisions
    # nodejs-10_x # javascript engine
    pandoc # utility that translates between markup formats
    # pass # stores, retrieves, generates, and sychronizes passwords securely
    patchelf
    pavucontrol # PulseAudio volume control
    pijul # distributed version control system inspired by categorical patches
    powertop # utility to analyze power consumption on Intel-based laptops
    # privoxy # non-caching web proxy with advanced filtering capabilities
    psmisc # utilities using the proc file-system (fuser, killall, pstree, etc)
    python
    ranger # file manager
    ripgrep # regex utility that's faster than the silver searcher ['rg']
    # rofi - window switcher, run dialog and dmenu replacement
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
    myVim # text editor
    virtualbox # hosted hypervisor (hardware virtualization); virtual-machine manager
    vlc # cross-platform media player and streaming server
    xclip # clipboard utility
    yarn # variant to npm
    # yi
    youtube-dl # command-line tool to download videos from video platforms
    zathura # PDF reader with vim bindings; plugin-based document viewer; can use mupdf as plugin
    zim # desktop wiki
  ];

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  programs = {
    bash = {
      enableCompletion = true;
      interactiveShellInit = "";
      loginShellInit = "";
      promptInit = builtins.readFile ./bash/prompt;
      shellAliases = {
        b = "cd ..";
        b1 = "cd ..";
        b2 = "cd ../..";
        b3 = "cd ../../..";
        b4 = "cd ../../../..";
        b5 = "cd ../../../../..";
        l = "ls -alh --color=tty";
        ls = "ls -a --color=tty";
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
      terminal = "screen-256color";
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "ctrl:nocaps";
  # services.xserver.synaptics.enable = true; # touchpad

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.desktopManager.xfce.enable = true;
  # services.xserver.windowManager.xmonad.enable = true;
  # services.xserver.windowManager.i3.enable = true;

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
    # layout = "dvorak";
    layout = "us";
    synaptics.enable = true; # touchpad
    xkbOptions = "ctrl:nocaps";
    windowManager.default = "i3";
  };

  # New users, don't forget to set a password with ‘passwd’.
  users = {
    mutableUsers = true;
    enforceIdUniqueness = true;
    users = {
      polytope = {
        createHome = true;
        cryptHomeLuks = null;
        description = "polytope";
        extraGroups = [ "wheel" "networkmanager" ];
        group = "users";
        hashedPassword = null;
        home = "/home/polytope";
        initialHashedPassword = null;
        initialPassword = null;
        isNormalUser = true;
        isSystemUser = false;
        packages = [];
        password = null;
        passwordFile = null;
        shell = pkgs.shadow;
        subGidRanges = [];
        subUidRanges = [];
        uid = null;
        useDefaultShell = true;
      };
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
