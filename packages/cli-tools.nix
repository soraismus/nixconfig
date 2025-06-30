{ pkgs }:

with pkgs; [
  bat                # pager + diff highlighter;
                     # a 'cat' clone with syntax highlighting and git integration
  bat-extras.batdiff # pager + diff highlighter
  broot              # interactive tree view, fuzzy search, balanced BFS descent
  difftastic         # syntax-aware diff-tool
  eza                # ls replacement
  fd                 # fast file-finder
  file               # program that shows the type of files
  fzf                # fuzzy everything
  jq                 # JSON wrangler
  jqp                # TUI playground for experimenting with jq
  maim               # cli screenshot utility [cf. scrot]
  mmv                # utility for wildcard renaming, copying, etc
  p7zip              # zip compressor/archiver
  psmisc             # utilities using the proc file-system (fuser, killall, pstree, etc)
  renameutils        # batch rename
  ripgrep            # recursive grep
  tldr               # community cheat-sheets
  tokei              # counts files, lines, code, comments, etc by language/file type
  translate-shell    # command-line translator
  tree               # directory tree
  units              # unit-conversion tool
]
