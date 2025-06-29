{ pkgs }:

with pkgs; [
  direnv           # automatic shell envs
  niv              # dependency manager for nix projects
  nix-diff         # utility that compares nix derivations
  nix-direnv       # automatic shell envs
  nix-index
  nix-prefetch-git # nix utility that aids in pinning github revisions
  nix-tree         # visualizer of dependecy closures

  # Consider
  # --------
  # lorri                   # project-scoped builds
  # nix-index-database      # “which package provides X?”
  # nix-output-monitor
  # nixpkgs-lint or statix
]
