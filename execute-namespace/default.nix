{ config, lib, pkgs, ... }:
let
  execute-namespace = pkgs.writeScriptBin "execute-namespace" ''
      #!${pkgs.bash}/bin/bash

      # This script requires at least one argument (cmd).
      # If 'cmd' doesn't exist, exit.
      if [[ $# == 0 ]]; then
        echo "  This script requires at least one argument (cmd, ...optional-args)"
        exit 1;
      fi

      local fn=$1
      shift
      local args="$@"

      # Start a subshell, in which all of the functions of ...
      # ... the namespace $NAMESPACE can be loaded.
      # In the subshell, run the function $fn with args $args.
      bash -c "source $NAMESPACES/$NAMESPACE; $fn $args"
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
