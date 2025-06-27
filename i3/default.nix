{ config, lib, pkgs, ... }:
let
  i3Config = ''
    # i3 config file (v4)
    #
    # Please see https://i3wm.org/docs/userguide.html for a complete reference!

    exec ${pkgs.feh}/bin/feh --bg-max '${./wallpapers/odin-on-sleipnir.jpg}'

    exec ${pkgs.ghostty}/bin/ghostty

    gaps inner 5
    gaps outer 3
    smart_gaps on
    smart_borders on

    set $mod Mod1

    # Font for window titles.
    # This will also be used by the bar
    # unless a different font is used in the bar {} block below.
    font pango:monospace 8

    # Use Mouse+$mod to drag floating windows to their wanted position.
    floating_modifier $mod

    # To start a terminal:
    bindsym $mod+Return exec ${pkgs.ghostty}/bin/ghostty

    # To kill focused window:
    bindsym $mod+Shift+q kill

    bindsym $mod+d exec rofi-dme
    bindsym $mod+t exec rofi-touchpad
    bindsym $mod+BackSpace exec rofi-pow
    bindsym $mod+Shift+w exec rofi-win
    bindsym $mod+z exec rofi-search

    # To change focus:
    bindsym $mod+h focus left
    bindsym $mod+j focus down
    bindsym $mod+k focus up
    bindsym $mod+l focus right

    # To move a focused window:
    bindsym $mod+Shift+h move left
    bindsym $mod+Shift+j move down
    bindsym $mod+Shift+k move up
    bindsym $mod+Shift+l move right

    # To split in the horizontal orientation.
    bindsym $mod+v split h

    # To split in the vertical orientation:
    bindsym $mod+s split v

    # To enter fullscreen mode for the focused container:
    bindsym $mod+f fullscreen toggle

    # To change the container layout (stacked, tabbed, toggle split):
    bindsym $mod+semicolon layout stacking
    bindsym $mod+w layout tabbed
    bindsym $mod+e layout toggle split

    # To toggle between tiling mode and floating mode:
    bindsym $mod+Shift+space floating toggle

    # To change focus between tiling / floating windows:
    bindsym $mod+space focus mode_toggle

    # To focus the parent container:
    bindsym $mod+a focus parent

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

    # To switch to a particular workspace:
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

    # To move a focused container to a particular workspace:
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

    # To reload the configuration file:
    bindsym $mod+Shift+c reload
    # To restart i3 inplace (preserves your layout/session, can be used to upgrade i3):
    bindsym $mod+Shift+r restart
    # To exit i3 (logs you out of your X session):
    bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"

    # To resize window (you can also use the mouse for that):
    mode "resize" {
            # These bindings trigger as soon as you enter the resize mode

            bindsym h resize shrink width 10 px or 10 ppt
            bindsym j resize grow height 10 px or 10 ppt
            bindsym k resize shrink height 10 px or 10 ppt
            bindsym l resize grow width 10 px or 10 ppt

            # To revert back to normal: Enter or Escape or $mod+r:
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
        [ pkgs.i3blocks # flexible scheduler for i3bar blocks
          pkgs.i3status # status line for i3bar, dzen2, xmobar, or lemonbar
          pkgs.ghostty # terminal emulator
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
