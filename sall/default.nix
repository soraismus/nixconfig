{ config, lib, pkgs, ... }:
let
  sall = pkgs.writeScriptBin "sall" ''
      #!${pkgs.bash}/bin/bash

      ${builtins.readFile ./definition}
    '';
in
{
  options.environment.theo.programs.sall = {
    enable = lib.mkEnableOption "sall";
  };

  config = lib.mkIf config.environment.theo.programs.sall.enable {
    environment.systemPackages = [ sall ];
  };
}
