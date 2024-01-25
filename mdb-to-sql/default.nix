{ config, lib, pkgs, ... }:
let
  bookmark = pkgs.writeScriptBin "mdb-to-sql" ''
      #!${pkgs.bash}/bin/bash
      set -o errexit
      set -o nounset
      set -o pipefail

      ${builtins.readFile ./definition}
    '';
in
{
  options.environment.theo.programs.mdb-to-sql = {
    enable = lib.mkEnableOption "mdb-to-sql";
  };

  config = lib.mkIf config.environment.theo.programs.mdb-to-sql.enable {
    environment.systemPackages = [ mdb-to-sql ];
  };
}
