{ config, lib, pkgs, ... }:
let
  # exec-zk = pkgs.writeShellScriptBin "zk" ''
  #   export ZK_NOTEBOOK_DIR="$HOME/zk-vault"
  #   exec ${pkgs.zk}/bin/zk "$@"
  # '';

  exec-zk = pkgs.writeShellScriptBin "zk" ''
    exec ${pkgs.zk}/bin/zk "$@"
  '';

  zk-vault-template = ''
    # {{ title }}

    Created: {{ created }}
    Updated: {{ modified }}

    Tags: #note
  '';

  zk-vault-toml = ''
    [zk]
    title = "My Zettelkasten"
    path = "/home/${config.users.users.polytope.name}/zk-vault"
    extensions = ["md"]
    default_template = "default"
    templates_dir = "/home/${config.users.users.polytope.name}/zk-vault/templates"
  '';

in
  {
    options.environment.theo.programs.zk = {
      enable = lib.mkEnableOption "zk";
    };

    config = lib.mkIf config.environment.theo.programs.zk.enable {
      environment.systemPackages =
        [
          exec-zk
          pkgs.zk
        ];

      environment = {
        etc = {
          # Write zk.toml directly into /etc (read-only, but OK if zk is used non-interactively)
          "zk-vault/zk.toml".text = zk-vault-toml;

          # Optional template (read-only unless you give write access elsewhere)
          "zk-vault/templates/default.md".text = zk-vault-template;
        };

        # variables = {
        #   ZK_EDITOR = "vim";
        #   ZK_NOTEBOOK_DIR = "/home/${config.users.users.polytope.name}/zk-vault";
        # };
      };

      programs.bash = {
        shellAliases = {
          zn = "zk new";
          zl = "zk list";
          zg = "zk grep";
        };
      };

    };
  }
