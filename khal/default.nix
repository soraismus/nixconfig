{ config, lib, pkgs, ... }:
let
  cfg = config.environment.fre.programs.khal;

  khal = config: pkgs.writeScriptBin "khal" ''
    #!${pkgs.stdenv.shell}
    ${pkgs.khal}/bin/khal -c ${config} $@
  '';

  ikhal = config: pkgs.writeScriptBin "ikhal" ''
    #!${pkgs.stdenv.shell}
    ${pkgs.khal}/bin/ikhal -c ${config} $@
  '';
in
  {
    options.environment.fre.programs.khal = {
      enable = lib.mkEnableOption "khal";

      config = lib.mkOption {
        type = types.string;
        default = "${builtins.toPath ./config}";
        description = ''
          Khal Configuration file
        '';
      };

    };

    config = lib.mkIf cfg.enable {
      environment.systemPackages = [
        (khal cfg.config)
        (ikhal cfg.config)
      ];
    };
  }
