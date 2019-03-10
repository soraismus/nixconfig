{ config, lib, pkgs, ... }:
let
  bookmark = pkgs.writeScriptBin "bookmark" ''
      #!${pkgs.bash}/bin/bash

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
