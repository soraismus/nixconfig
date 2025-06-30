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
  ++ [ pkgs.myPython
       pkgs.myRstudio
     ]

# Consider (This section is for documentation.)
# ----------------------------------------------
# borgmatic         # configuration-driven backup software
# difftastic        # syntax-aware diff
# espanso           # cross-platform text expander
# expect            # tool for automating interactive applications
# ffuf              # fast web fuzzer; web scraper
# fselect           # find files with sql-like syntax
# hyperfine         # benchmarking tool
# just / justbuild  # command runner (make alternative)
# lc0               # neural-network-based chess engine
# mprocs            # tui for running multiple commands
# niri              # scrollable-tiling wayland compositor
# obsidian          # knowledge base [cf. zk]
# parallel          # shell tool fro executing jobs in parallel [cf. xargs ?]
# privoxy           # non-caching web proxy with advanced filtering capabilities
# psmisc            # utilities using the proc file-system (fuser, killall, pstree, etc)
# pychess           # gtk chess client
# scid              # chess database with play and training functionality
# stockfish         # chess engine
# tokei             # counts files, line, comments, blanks.
# wiki-tui          # tui for wikipedia
# zk                # zettelkasten note-taking [cf. obsidian]
