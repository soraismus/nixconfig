{ pkgs }:

with pkgs; [
  brave    # privacy-oriented browser
  chromium
  firefox
  links2   # small browser with graphics support (`-g`) (cf. browsh, lynx, w3m)
  lynx     # terminal web-browser (cf. browsh, links2, w3m)
  w3m      # text-based web browser (cf. browsh, links2, lynx)

  # Consider
  # --------
  # browsh       # text-based browser that can render css and js (cf. links2, lynx, w3m)
  # librewolf
  # qutebrowser  # keyboard-focused browser
  # vieb         # vim-inspired electron browser
]
