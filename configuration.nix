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
      import ./packages/system-packages.nix { inherit config lib pkgs; };

  environment.theo = {
    programs = {
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
    packages = import ./packages/fonts.nix { inherit pkgs; };
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
