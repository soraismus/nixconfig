{ config, lib, pkgs, ... }:
let
  rofi-config = ''
    _rofi () {
        rofi -i -width 700 -no-levenshtein-sort -theme ${./flat-orange.rasi} "$@"
    }

    # fields to be used
    URL_field='url'
    USERNAME_field='user'
    AUTOTYPE_field='autotype'

    # delay to be used for :delay keyword
    delay=2

    ## Programs to be used
    # Editor
    # EDITOR='gvim -f'
    EDITOR='vim'

    # Browser
    # BROWSER='qtb'
    BROWSER='firefox'

    ## Misc settings

    default_do='typePass'
    auto_enter='false'
    notify='false'
    passlength='20'

    # seconds to wait before re-opening showEntry-menu
    # after autotyping an entry. Set to "off" to disable
    count=2

    # color of the help messages
    # leave empty for autodetection
    help_color=""

    # Clipboard settings
    # Possible options: primary, clipboard, both
    clip=clipboard

    # Options for generating new password entries
    default_user=polytope
    password_length=12

    # Custom Keybindings
    autotype="Control+1"
    type_user="Control+2"
    type_pass="Control+3"
    open_url="Control+4"
    copy_name="Control+u"
    copy_url="Control+l"
    copy_pass="Control+p"
    show="Control+o"
    copy_entry="Control+2"
    type_entry="Control+1"
    copy_menu="Control+c"
    action_menu="Control+a"
    type_menu="Control+t"
    help="Control+h"
    switch="Control+x"
    insert_pass="Control+n"
  '';

  rofi-dme = pkgs.writeScriptBin "rofi-dme" ''
    ${pkgs.rofi}/bin/rofi \
      -show run \
      -run-command 'i3 exec {cmd}' \
      -theme ${./flat-orange.rasi}
  '';

  rofi-password-store-config = ''
    _rofi () {
        rofi -i -theme ${./flat-orange.rasi} -width 700 -no-levenshtein-sort "$@"
    }

    URL_field='url'
    USERNAME_field='user'
    AUTOTYPE_field='autotype'
    delay=2
    # EDITOR='gvim -f'
    EDITOR='vim'
    # BROWSER='qtb'
    BROWSER='firefox'
    default_do='typePass'
    auto_enter='false'
    notify='false'
    passlength='20'
    count=2
    help_color=""
    clip=clipboard
    default_user=fre
    password_length=12
    autotype="Control+1"
    type_user="Control+2"
    type_pass="Control+3"
    open_url="Control+4"
    #copy_name="Control+u"
    copy_url="Control+l"
    #copy_pass="Control+p"
    show="Control+o"
    copy_entry="Control+2"
    type_entry="Control+1"
    copy_menu="Control+c"
    #action_menu="Control+a"
    type_menu="Control+t"
    #help="Control+h"
    switch="Control+x"
    #insert_pass="Control+n"
  '';

  rofi-search = pkgs.writeScriptBin "rofi-search" ''
    #!${pkgs.bash}/bin/bash
    declare -A URLS
    URLS=(
      ["duckduckgo"]="https://www.duckduckgo.com/?q="
      ["github"]="https://github.com/search?q="
      ["stackoverflow"]="http://stackoverflow.com/search?q="
      ["symbolhound"]="http://symbolhound.com/?q="
      ["openhub"]="https://www.openhub.net/p?ref=homepage&query="
      ["hound-nix"]="https://search.nix.gsc.io/?q="
      ["rottentomatoes"]="https://www.rottentomatoes.com/search/?search="
      ["youtube"]="https://www.youtube.com/results?search_query="
      ["wordreference/enfr"]="http://www.wordreference.com/enfr/"
    )
    gen_list() {
        for i in "''${!URLS[@]}"
        do
          echo "$i"
        done
    }

    main() {
      # Pass the list to rofi
      platform=$( (gen_list) \
        | rofi -dmenu -fuzzy -only-match -location 0 -p "Search \
        > " -theme ${./flat-orange.rasi})

      query=$(
          (echo) \
            | rofi  -dmenu -fuzzy -location 0 -p "Query \
            > " -theme ${./flat-orange.rasi} \
        )
      if [[ -n "$query" ]]; then
        url=''${URLS[$platform]}$query
        firefox --new-window "$url"
      else
        rofi -show -e "No query provided." -theme ${./flat-orange.rasi}
      fi
    }

    main

    exit 0
  '';

  rofi-show-window = pkgs.writeScriptBin "rofi-win" ''
    ${pkgs.rofi}/bin/rofi -show window -theme ${./flat-orange.rasi}
  '';

  rofi-ssh = pkgs.writeScriptBin "rofi-ssh" ''
    ${pkgs.rofi}/bin/rofi \
      -show ssh \
      -theme ${./flat-orange.rasi} \
      --ssh-command "${pkgs.rxvt_unicode}/bin/urxvt \
      -e '{ssh-client} {host}'"
    '';


  rofi-touchpad = pkgs.writeScriptBin "rofi-touchpad" ''
    #!${pkgs.bash}/bin/bash

    OPTIONS="Toggle touchpad""
    LAUNCHER="rofi -width 30 -theme ${./flat-orange.rasi} -dmenu -i -p rofi-touchpad:"
    USE_LOCKER="false"
    LOCKER="i3lock"

    option=`echo -e $OPTIONS | $LAUNCHER | awk '{print $1}' | tr -d '\r\n'`
    if [ ''${#option} -gt 0 ]
    then
        case $option in
          Toggle)
            toggleTouchpad
            ;;
          *)
            ;;
        esac
    fi
  '';

  rofi-system-power = pkgs.writeScriptBin "rofi-pow" ''
    #!${pkgs.bash}/bin/bash

    OPTIONS="Reboot system\nPower-off system\nSuspend system\nHibernate system"
    LAUNCHER="rofi -width 30 -theme ${./flat-orange.rasi} -dmenu -i -p rofi-power:"
    USE_LOCKER="false"
    LOCKER="i3lock"

    # Show exit wm option if exit command is provided as an argument
    if [ ''${#1} -gt 0 ]; then
      OPTIONS="Exit window manager\n$OPTIONS"
    fi

    option=`echo -e $OPTIONS | $LAUNCHER | awk '{print $1}' | tr -d '\r\n'`
    if [ ''${#option} -gt 0 ]
    then
        case $option in
          Exit)
            i3-msg exit
            ;;
          Reboot)
            systemctl reboot
            ;;
          Power-off)
            systemctl poweroff
            ;;
          Suspend)
            $($USE_LOCKER) && "$LOCKER"; systemctl suspend
            ;;
          Hibernate)
            $($USE_LOCKER) && "$LOCKER"; systemctl hibernate
            ;;
          *)
            ;;
        esac
    fi
  '';

  rofi-theme = pkgs.writeScriptBin "rofi-theme" ''
    #!${pkgs.bash}/bin/bash
    ${pkgs.pass}/bin/rofi -theme ${./flat-orange.rasi}
  '';
in
  {
    options.environment.theo.programs.rofi = {
      enable = lib.mkEnableOption "rofi";
    };

    config = lib.mkIf config.environment.theo.programs.rofi.enable {
      environment.systemPackages =
        [ pkgs.rofi-pass
          pkgs.rofi
          rofi-dme
          rofi-search
          rofi-show-window
          rofi-ssh
          rofi-system-power
          rofi-touchpad
          rofi-theme
      ];

      environment.etc."rofi.conf".text = rofi-config;

      environment.etc."rofi-pass.conf".text= rofi-password-store-config;
    };
  }
