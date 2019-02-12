{ config, lib, pkgs, ... }:
{
  options.environment.theo.services.conky = {
    enable = lib.mkEnableOption "conky";
  };

  config = lib.mkIf config.environment.theo.services.conky.enable {
    config.environment.theo.programs.khal.enable = true;

    environment.systemPackages= [
      pkgs.conky # configurable system monitor based on torsmo
      pkgs.khal # CLI calendar application
    ];

    systemd.services =
    {
      "conky-left" =
      {
        enable = true;
        description = "Conky left";
        after = [ "graphical-session.target" ];
        wantedBy = [ "default.target" ];
        environment = {
          DISPLAY = ":0.0";
          KHAL = "${pkgs.khal}/bin/khal -c ${../khal/config}";
        };
        serviceConfig = {
          User = "polytope";
          Restart = "always";
          RestartSec = "3";
          ExecStart = "${pkgs.conky}/bin/conky -c ${./left.cfg}";
        };
      };
    };
  };
}
