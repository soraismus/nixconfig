{ config, lib, pkgs, ... }:
let
  bookmark = pkgs.writeScriptBin "bookmark" ''
      #!${pkgs.bash}/bin/bash
      set -o errexit
      set -o nounset
      set -o pipefail

      ${builtins.readFile ./definition}
    '';
in
{
  options.environment.theo.programs.bookmark = {
    enable = lib.mkEnableOption "bookmark";
  };

  config = lib.mkIf config.environment.theo.programs.bookmark.enable {
    environment.systemPackages =
      [ bookmark
        pkgs.pandoc
      ];
  };
}
