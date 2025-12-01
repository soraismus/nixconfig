{ pkgs }:
let
  callPackage = pkgs.lib.callPackageWith pkgs;
in
  [ pkgs.powerline-fonts
    pkgs.font-awesome # font-awesome-ttf -> font-awesome
    pkgs.hasklig
    pkgs.inconsolata
    pkgs.ubuntu-classic
    pkgs.liberation_ttf
    pkgs.unifont
    pkgs.fira-code
    pkgs.iosevka
    pkgs.fira-mono
    pkgs.terminus_font
    pkgs.fira
    (callPackage ../tsundoku-font {})
  ]
