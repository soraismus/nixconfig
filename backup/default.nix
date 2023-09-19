{ config, lib, pkgs, ... }:
let
  backup = pkgs.writeScriptBin "backup" ''
      #!${pkgs.bash}/bin/bash

      ${builtins.readFile ./definition}
    '';
in
{
  options.environment.theo.programs.backup = {
    enable = lib.mkEnableOption "backup";
  };

  config = lib.mkIf config.environment.theo.programs.backup.enable {
    environment.systemPackages = [ backup ];
  };
}
