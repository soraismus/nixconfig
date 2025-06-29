{ config, lib, pkgs, ... }:
{
  options.environment.theo.programs.tmux = {
    enable = lib.mkEnableOption "tmux";
  };

  config = lib.mkIf config.environment.theo.programs.tmux.enable {
    environment.systemPackages = [
      pkgs.tmux
      pkgs.tmuxp # Manage tmux workspaces from JSON and YAML.
    ];

    programs.tmux = {
      enable = true;
      aggressiveResize = false;
      baseIndex = 0;
      clock24 = true;
      customPaneNavigationAndResize = true;
      escapeTime = 500;
      extraConfig = builtins.readFile ./tmux.conf;
      historyLimit = 10000;
      keyMode = "vi";
      newSession = true;
      reverseSplit = true;
      resizeAmount = 10;
      secureSocket = true;
      shortcut = "f";
      terminal = "screen-256color"; # Default value is "screen".
    };
  };
}
