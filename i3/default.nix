{ config, lib, pkgs, ... }:
let
  i3Config = ''
    # i3 config file (v4)
    #
    # Please see https://i3wm.org/docs/userguide.html for a complete reference!

    exec ${pkgs.feh}/bin/feh --bg-scale '${./wallpapers/universe-is-created--gauguin.jpg}'
    exec ${pkgs.rxvt_unicode}/bin/urxvt

    gaps inner 5
    gaps outer 3
    smart_gaps on
    smart_borders on

    set $mod Mod1

    # Font for window titles. Will also be used by the bar unless a different font
    # is used in the bar {} block below.
    font pango:monospace 8

    # This font is widely installed, provides lots of unicode glyphs, right-to-left
    # text rendering and scalability on retina/hidpi displays (thanks to pango).
    #font pango:DejaVu Sans Mono 8

    # Before i3 v4.8, we used to recommend this one as the default:
    # font -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1
    # The font above is very space-efficient, that is, it looks good, sharp and
    # clear in small sizes. However, its unicode glyph coverage is limited, the old
    # X core fonts rendering does not support right-to-left and this being a bitmap
    # font, it doesn’t scale on retina/hidpi displays.

    # Use Mouse+$mod to drag floating windows to their wanted position
    floating_modifier $mod

    # start a terminal
    # bindsym $mod+Return exec i3-sensible-terminal
    bindsym $mod+Return exec ${pkgs.rxvt_unicode}/bin/urxvt

    # kill focused window
    bindsym $mod+Shift+q kill

    # start dmenu (a program launcher)
    #bindsym $mod+d exec dmenu_run
    # There also is the (new) i3-dmenu-desktop which only displays applications
    # shipping a .desktop file. It is a wrapper around dmenu,
    # so you need that installed.
    # bindsym $mod+d exec --no-startup-id i3-dmenu-desktop
    bindsym $mod+d exec rofi-dme
    bindsym $mod+t exec rofi-touchpad
    bindsym $mod+BackSpace exec rofi-pow
    bindsym $mod+c exec ${pkgs.bash}/bin/bash -c rofi-pass
    bindsym $mod+Shift+w exec rofi-win
    bindsym $mod+z exec rofi-search

    # change focus
    #bindsym $mod+j focus left
    #bindsym $mod+k focus down
    #bindsym $mod+l focus up
    #bindsym $mod+semicolon focus right
    bindsym $mod+h focus left
    bindsym $mod+j focus down
    bindsym $mod+k focus up
    bindsym $mod+l focus right

    # alternatively, you can use the cursor keys:
    #bindsym $mod+Left focus left
    #bindsym $mod+Down focus down
    #bindsym $mod+Up focus up
    #bindsym $mod+Right focus right

    # move focused window
    #bindsym $mod+Shift+j move left
    #bindsym $mod+Shift+k move down
    #bindsym $mod+Shift+l move up
    #bindsym $mod+Shift+semicolon move right
    bindsym $mod+Shift+h move left
    bindsym $mod+Shift+j move down
    bindsym $mod+Shift+k move up
    bindsym $mod+Shift+l move right

    # alternatively, you can use the cursor keys:
    #bindsym $mod+Shift+Left move left
    #bindsym $mod+Shift+Down move down
    #bindsym $mod+Shift+Up move up
    #bindsym $mod+Shift+Right move right

    # split in horizontal orientation
    #bindsym $mod+h split h
    bindsym $mod+v split h

    # split in vertical orientation
    bindsym $mod+s split v

    # enter fullscreen mode for the focused container
    bindsym $mod+f fullscreen toggle

    # change container layout (stacked, tabbed, toggle split)
    #bindsym $mod+s layout stacking
    bindsym $mod+semicolon layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split

    # toggle tiling / floating
    bindsym $mod+Shift+space floating toggle

    # change focus between tiling / floating windows
    bindsym $mod+space focus mode_toggle

    # focus the parent container
    bindsym $mod+a focus parent

    # focus the child container
    #bindsym $mod+d focus child

    # Define names for default workspaces for which we configure key bindings later on.
    # We use variables to avoid repeating the names in multiple places.
    set $ws1 "1"
    set $ws2 "2"
    set $ws3 "3"
    set $ws4 "4"
    set $ws5 "5"
    set $ws6 "6"
    set $ws7 "7"
    set $ws8 "8"
    set $ws9 "9"
    set $ws10 "10"

    # switch to workspace
    bindsym $mod+1 workspace $ws1
    bindsym $mod+2 workspace $ws2
    bindsym $mod+3 workspace $ws3
    bindsym $mod+4 workspace $ws4
    bindsym $mod+5 workspace $ws5
    bindsym $mod+6 workspace $ws6
    bindsym $mod+7 workspace $ws7
    bindsym $mod+8 workspace $ws8
    bindsym $mod+9 workspace $ws9
    bindsym $mod+0 workspace $ws10

    # move focused container to workspace
    bindsym $mod+Shift+1 move container to workspace $ws1
    bindsym $mod+Shift+2 move container to workspace $ws2
    bindsym $mod+Shift+3 move container to workspace $ws3
    bindsym $mod+Shift+4 move container to workspace $ws4
    bindsym $mod+Shift+5 move container to workspace $ws5
    bindsym $mod+Shift+6 move container to workspace $ws6
    bindsym $mod+Shift+7 move container to workspace $ws7
    bindsym $mod+Shift+8 move container to workspace $ws8
    bindsym $mod+Shift+9 move container to workspace $ws9
    bindsym $mod+Shift+0 move container to workspace $ws10

    # reload the configuration file
    bindsym $mod+Shift+c reload
    # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
    bindsym $mod+Shift+r restart
    # exit i3 (logs you out of your X session)
    bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"

    # resize window (you can also use the mouse for that)
    mode "resize" {
            # These bindings trigger as soon as you enter the resize mode

            # Pressing left will shrink the window’s width.
            # Pressing right will grow the window’s width.
            # Pressing up will shrink the window’s height.
            # Pressing down will grow the window’s height.
            #bindsym j resize shrink width 10 px or 10 ppt
            #bindsym k resize grow height 10 px or 10 ppt
            #bindsym l resize shrink height 10 px or 10 ppt
            #bindsym semicolon resize grow width 10 px or 10 ppt
            bindsym h resize shrink width 10 px or 10 ppt
            bindsym j resize grow height 10 px or 10 ppt
            bindsym k resize shrink height 10 px or 10 ppt
            bindsym l resize grow width 10 px or 10 ppt

            # same bindings, but for the arrow keys
            #bindsym Left resize shrink width 10 px or 10 ppt
            #bindsym Down resize grow height 10 px or 10 ppt
            #bindsym Up resize shrink height 10 px or 10 ppt
            #bindsym Right resize grow width 10 px or 10 ppt

            # back to normal: Enter or Escape or $mod+r
            bindsym Return mode "default"
            bindsym Escape mode "default"
            bindsym $mod+r mode "default"
    }

    bindsym $mod+r mode "resize"

    # Start i3bar to display a workspace bar (plus the system information i3status
    # finds out, if available)
    bar {
            status_command i3status
    }
  '';
in
  {
    options.environment.theo.services.i3 = {
      enable = lib.mkEnableOption "i3";
    };

    config = lib.mkIf config.environment.theo.services.i3.enable {
      environment.systemPackages =
        [ pkgs.dmenu
          pkgs.i3blocks
          # pkgs.i3lock
          pkgs.i3status
          pkgs.rxvt_unicode # clone of rxvt (color vt102 terminal emulator)
        ];
      services.xserver.windowManager.i3 = {
        enable = true;
        configFile = pkgs.writeText "i3.conf" i3Config;
        extraPackages = [];
        extraSessionCommands = "";
        package = pkgs.i3-gaps;
      };
    };
  }
