{ pkgs }:

with pkgs; [
  bat                # pager + diff highlighter;
                     # a 'cat' clone with syntax highlighting and git integration
  bat-extras.batdiff # pager + diff highlighter
  broot              # interactive tree view, fuzzy search, balanced BFS descent
  eza                # ls replacement
  fd                 # fast file-finder
  file               # program that shows the type of files
  fzf                # fuzzy everything
  jq                 # JSON wrangler
  jqp                # TUI playground for experimenting with jq
  maim               # cli screenshot utility [cf. scrot]
  mmv                # utility for wildcard renaming, copying, etc
  p7zip              # zip compressor/archiver
  renameutils        # batch rename
  ripgrep            # recursive grep
  tldr               # community cheat-sheets
  translate-shell    # command-line translator
  tree               # directory tree
  units              # unit-conversion tool
]
