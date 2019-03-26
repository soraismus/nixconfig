{ config, lib, pkgs, ... }:
let
  execute-namespace = pkgs.writeScriptBin "execute-namespace" ''
      #!${pkgs.bash}/bin/bash

      ${builtins.readFile ./definition}
    '';
in
{
  options.environment.theo.programs.execute-namespace = {
    enable = lib.mkEnableOption "execute-namespace";
  };

  config = lib.mkIf config.environment.theo.programs.execute-namespace.enable {
    environment.systemPackages = [execute-namespace];
  };
}
