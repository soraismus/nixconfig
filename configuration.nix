# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Modules:
      # --------
      ./automatic-mac-spoofing/default.nix
      ./backup/default.nix
      ./bash/default.nix
      ./bookmark/default.nix
      ./execute-namespace/default.nix
      ./format-purs-json-errors-output/default.nix
      ./git/default.nix
      ./i3/default.nix
      ./mdb-to-sql/default.nix
      ./rofi/default.nix
      ./tmux/default.nix
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

  environment.systemPackages =
    let
      browsers = import ./packages/browsers.nix { inherit pkgs; };
      cli-tools = import ./packages/cli-tools.nix { inherit pkgs; };
      dev-tools = import ./packages/dev-tools.nix { inherit pkgs; };

      editing-and-terminal-tools =
        import ./packages/editing-and-terminal-tools.nix { inherit config lib pkgs; };

      media-tools = import ./packages/media-tools.nix { inherit pkgs; };
      monitoring-and-diagnostic-tools = import ./packages/monitoring-and-diagnostic-tools.nix { inherit pkgs; };
      networking-and-security-tools = import ./packages/networking-and-security-tools.nix { inherit pkgs; };
      nix-tools = import ./packages/nix-tools.nix { inherit pkgs; };
      shell-ux = import ./packages/shell-ux.nix { inherit pkgs; };
    in
         browsers
      ++ cli-tools
      ++ dev-tools
      ++ editing-and-terminal-tools
      ++ media-tools
      ++ monitoring-and-diagnostic-tools
      ++ networking-and-security-tools
      ++ nix-tools
      ++ shell-ux
      ++ [ pkgs.myPython
           pkgs.myRstudio
         ];
    # Consider (This section is for documentation.)
    # ----------------------------------------------
      # borgmatic         # configuration-driven backup software
      # difftastic        # syntax-aware diff
      # espanso           # cross-platform text expander
      # expect            # tool for automating interactive applications
      # ffuf              # fast web fuzzer; web scraper
      # fselect           # find files with sql-like syntax
      # hyperfine         # benchmarking tool
      # just / justbuild  # command runner (make alternative)
      # lc0               # neural-network-based chess engine
      # mprocs            # tui for running multiple commands
      # niri              # scrollable-tiling wayland compositor
      # obsidian          # knowledge base [cf. zk]
      # parallel          # shell tool fro executing jobs in parallel [cf. xargs ?]
      # privoxy           # non-caching web proxy with advanced filtering capabilities
      # psmisc            # utilities using the proc file-system (fuser, killall, pstree, etc)
      # pychess           # gtk chess client
      # scid              # chess database with play and training functionality
      # stockfish         # chess engine
      # tokei             # counts files, line, comments, blanks.
      # wiki-tui          # tui for wikipedia
      # zk                # zettelkasten note-taking [cf. obsidian]

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
      bash.enable = true;
      bookmark.enable = true;
      execute-namespace.enable = true;
      format-purs-json-errors-output.enable = true;
      git.enable = true;
      mdb-to-sql.enable = true;
      rofi.enable = true;
      tmux.enable = true;
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
    overlays = [
      (import ./overlays/my-python.nix)
      (import ./overlays/my-rstudio.nix)
    ];
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
