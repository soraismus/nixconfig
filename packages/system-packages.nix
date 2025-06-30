{ config, lib, pkgs }:

let
  browsers = import ./browsers.nix { inherit pkgs; };
  cli-tools = import ./cli-tools.nix { inherit pkgs; };
  dev-tools = import ./dev-tools.nix { inherit pkgs; };

  editing-and-terminal-tools =
    import ./editing-and-terminal-tools.nix { inherit config lib pkgs; };

  media-tools = import ./media-tools.nix { inherit pkgs; };
  monitoring-and-diagnostic-tools = import ./monitoring-and-diagnostic-tools.nix { inherit pkgs; };
  networking-and-security-tools = import ./networking-and-security-tools.nix { inherit pkgs; };
  nix-tools = import ./nix-tools.nix { inherit pkgs; };
  shell-ux = import ./shell-ux.nix { inherit pkgs; };
  workflow-and-automation-tools = import ./workflow-and-automation-tools.nix { inherit pkgs; };
in
     browsers
  ++ cli-tools
  ++ dev-tools
  ++ editing-and-terminal-tools
  ++ media-tools
  ++ monitoring-and-diagnostic-tools
  ++ networking-and-security-tools
  ++ nix-tools
  ++ shell-ux
  ++ workflow-and-automation-tools
  ++ [ pkgs.myPython
       pkgs.myRstudio
     ]

# Consider (This section is for documentation.)
# ----------------------------------------------

# 0. Chess
# --------
# lc0        # neural-network-based chess engine
# pychess    # gtk chess client
# scid       # chess database with play and training functionality
# stockfish  # chess engine

# 1. Miscellaneous
# -----------------
# borgmatic  # configuration-driven backup software
# espanso    # cross-platform text expander;
#            # text expansion; great for typing macros, but has runtime daemons
# expect     # tool for automating interactive cli programs that require user input
# ffuf       # fast web fuzzer; web scraper; web recon.
# privoxy    # non-caching web proxy with advanced filtering capabilities;
#            # programmable local proxy
