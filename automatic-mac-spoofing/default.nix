{ config, lib, pkgs, ... }:
{
  options.environment.theo.services.automatic-mac-spoofing = {
    enable = lib.mkEnableOption "automatic-mac-spoofing";
  };

  config = lib.mkIf config.environment.theo.services.automatic-mac-spoofing.enable {
    environment.systemPackages = [ pkgs.macchanger ];

    systemd.services."macspoofing" = {
      enable = true;
      description ="macchanger on wlp2s0";
      wants = [ "network-pre.target" ];
      wantedBy = [ "multi-user.target" ];
      before = [ "network-pre.target" ];
      bindsTo = [ "sys-subsystem-net-devices-wlp2s0.device" ];
      after = [ "sys-subsystem-net-devices-wlp2s0.device" ];
      serviceConfig = {
        ExecStart= "${pkgs.macchanger}/bin/macchanger -e wlp2s0";
        Type = "oneshot";
      };
    };
  };
}
