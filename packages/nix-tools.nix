{ pkgs }:

with pkgs; [
  direnv               # automatic shell envs
  niv                  # dependency manager for nix projects
  nix-diff             # utility that compares nix derivations
  nix-direnv           # automatic shell envs

  nix-index            # tool that builds an index that maps paths to derivations;
                       # “which package provides X?”
                       # provides 'nix-locate' for querying:
                       # e.g., `nix-locate bin/ffmpeg`
                       # `nix-locate include/string.h`
                       # cf. !gh nix-community/nix-index-database

  nix-output-monitor   # real-time progress and timing info for nixos-rebuild, etc.
                       # `nix build . --print-build-logs --json | nom`
                       # `nixos-rebuild switch --log-format raw |& nom`

  nix-prefetch-git     # nix utility that aids in pinning github revisions
  nix-tree             # visualizer of dependecy closures
]
