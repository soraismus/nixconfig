{ config, lib, pkgs, ... }:
let
  format-purs-json-errors-output = pkgs.writeScriptBin "format-purs-json-errors-output" ''
      #!${pkgs.bash}/bin/bash
      set -o errexit
      set -o nounset
      set -o pipefail

      ${builtins.readFile ./definition}
    '';
in
{
  options.environment.theo.programs.format-purs-json-errors-output = {
    enable = lib.mkEnableOption "format-purs-json-errors-output";
  };

  config = lib.mkIf config.environment.theo.programs.format-purs-json-errors-output.enable {
    environment.systemPackages =
      [ format-purs-json-errors-output
      ];
  };
}
