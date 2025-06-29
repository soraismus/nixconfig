{ pkgs }:

with pkgs; [
  ghostty # gpu terminal
  myVim
  neovim
  tmux
  tmuxp   # manage tmux workspaces from JSON and YAML
  xclip   # clipboard utility
  xdotool # fake keyboard/mouse input, window management
  xdragon # simple drag-and-drop source/sink for x

  # Consider
  # --------
  # atuin      # db-persisted shell-history manager
  # evil-helix # modal text editor (vim alternative)
  # nushell    # shell inspired by powershell written in rust
  # zellij     # tmux alternative
]
