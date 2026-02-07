{ pkgs }:
let
  dracula = import ./dracula.nix;
in
''
  set $mod Mod4

  font pango:monospace 8.000000
  floating_modifier $mod
  default_border pixel 4
  default_floating_border normal 2
  hide_edge_borders none
  focus_wrapping no
  focus_follows_mouse yes
  focus_on_window_activation smart
  mouse_warping output
  workspace_layout default
  workspace_auto_back_and_forth yes

  # order of colors is: border, background, text, indicator, childBorder
  # "indicator" indicates where a new window will open.
  # I think "text" and "border" only apply to titlebars, which I am not showing.
   
  client.focused #000000 ${dracula.blueGrey} #ffffff ${dracula.green} ${dracula.purple}  

  # I choose not to distinguish in style between focusedInactive and unfocused
  client.focused_inactive #000000 ${dracula.darkGrey} ${dracula.lightGrey} ${dracula.darkGrey} ${dracula.darkGrey}
  client.unfocused #000000 ${dracula.darkGrey} ${dracula.lightGrey} ${dracula.darkGrey} ${dracula.darkGrey}

  client.urgent #000000 ${dracula.red} ${dracula.lightGrey} ${dracula.green} ${dracula.red}

  # For placeholder colors, background and text color are used to draw placeholder window contents (when restoring layouts). Border and indicator are ignored.
  client.placeholder #000000 ${dracula.darkGrey} ${dracula.lightGrey} #000000 #000000

  client.background ${dracula.lightGrey}

  bindsym $mod+Shift+a focus child
  bindsym $mod+0 workspace number 10
  bindsym $mod+1 workspace number 1
  bindsym $mod+2 workspace number 2
  bindsym $mod+3 workspace number 3
  bindsym $mod+4 workspace number 4
  bindsym $mod+5 workspace number 5
  bindsym $mod+6 workspace number 6
  bindsym $mod+7 workspace number 7
  bindsym $mod+8 workspace number 8
  bindsym $mod+9 workspace number 9
  bindsym $mod+Down focus down
  bindsym $mod+Left focus left
  bindsym $mod+Return exec ghostty
  bindsym $mod+Right focus right
  bindsym $mod+Shift+0 move container to workspace number 10
  bindsym $mod+Shift+1 move container to workspace number 1
  bindsym $mod+Shift+2 move container to workspace number 2
  bindsym $mod+Shift+3 move container to workspace number 3
  bindsym $mod+Shift+4 move container to workspace number 4
  bindsym $mod+Shift+5 move container to workspace number 5
  bindsym $mod+Shift+6 move container to workspace number 6
  bindsym $mod+Shift+7 move container to workspace number 7
  bindsym $mod+Shift+8 move container to workspace number 8
  bindsym $mod+Shift+9 move container to workspace number 9
  bindsym $mod+Shift+Down move down
  bindsym $mod+Shift+Left move left
  bindsym $mod+Shift+Right move right
  bindsym $mod+Shift+Up move up
  bindsym $mod+Shift+c reload
  bindsym $mod+Shift+e exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'
  bindsym $mod+Shift+h move left
  bindsym $mod+Shift+j move down
  bindsym $mod+Shift+k move up
  bindsym $mod+Shift+l move right
  bindsym $mod+Shift+minus move scratchpad
  bindsym $mod+Shift+q kill
  bindsym $mod+Shift+space floating toggle
  bindsym $mod+Up focus up
  bindsym $mod+a focus parent
  bindsym $mod+b splith
  bindsym $mod+d exec wofi --show run,drun
  bindsym $mod+e layout toggle split
  bindsym $mod+f fullscreen toggle
  bindsym $mod+h focus left
  bindsym $mod+j focus down
  bindsym $mod+k focus up
  bindsym $mod+l focus right
  bindsym $mod+minus scratchpad show
  bindsym $mod+r mode resize
  bindsym $mod+s layout stacking
  bindsym $mod+space focus mode_toggle
  bindsym $mod+v splitv
  bindsym $mod+w layout tabbed
  bindsym XF86AudioLowerVolume exec pactl set-sink-volume @DEFAULT_SINK@ -5%
  bindsym XF86AudioMicMute exec pactl set-source-mute @DEFAULT_SINK@ toggle
  bindsym XF86AudioMute exec pactl set-sink-mute @DEFAULT_SINK@ toggle
  bindsym XF86AudioRaiseVolume exec pactl set-sink-volume @DEFAULT_SINK@ +5%
  bindsym XF86MonBrightnessDown exec brightnessctl set 5%-
  bindsym XF86MonBrightnessUp exec brightnessctl set +5%

  # macOS style gestures to switch spaces
  bindgesture swipe:right workspace prev
  bindgesture swipe:left workspace next

  input "type:keyboard" {
    xkb_layout gb
  }


  input "type:touchpad" {
    # Disable while typing
    dwt yes
    # Just use a light tap for click, not a massive clunk
    tap yes
  }

  mode "resize" {
    bindsym Down resize grow height 10 px
    bindsym Escape mode default
    bindsym Left resize shrink width 10 px
    bindsym Return mode default
    bindsym Right resize grow width 10 px
    bindsym Up resize shrink height 10 px
    bindsym h resize shrink width 10 px
    bindsym j resize grow height 10 px
    bindsym k resize shrink height 10 px
    bindsym l resize grow width 10 px
  }

  bar {
    font pango:monospace 8.000000
    swaybar_command waybar
  }

  exec "${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP XDG_SESSION_TYPE NIXOS_OZONE_WL XCURSOR_THEME XCURSOR_SIZE; systemctl --user reset-failed && systemctl --user start sway-session.target && swaymsg -mt subscribe '[]' || true && systemctl --user stop sway-session.target"

  seat * xcursor_theme Adwaita 24

  # assign [app_id="com.mitchellh.ghostty-initial"] workspace 1
  # assign [app_id="google-chrome-initial"] workspace 2
  # exec ghostty --class=com.mitchellh.ghostty-initial
  # exec google-chrome-stable --class=google-chrome-initial
''
