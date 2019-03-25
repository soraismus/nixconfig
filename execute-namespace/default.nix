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

      fn=$1
      shift
      args="$@"
      args="${args[@]//";"/"\\;"}" # Escape all semicolons in "$args[@]".
      args="${args[@]//"&"/"\\&"}" # Escape all ampersands in "$args[@]".
      args="${args[@]//"|"/"\\|"}" # Escape all pipes in "$args[@]".
      args="${args[@]//">"/"\\>"}" # Escape all greater-than signs in "$args[@]".
      args="${args[@]//"<"/"\\<"}" # Escape all less-than signs in "$args[@]".

      # Start a subshell, in which all of the functions of ...
      # ... the namespace $NAMESPACE can be loaded.
      # In the subshell, run the function $fn with args $args.
      bash -c "source ${NAMESPACES}/${NAMESPACE}; ${fn} ${args[@]}"
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
