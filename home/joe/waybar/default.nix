{ lib }:
let
  dracula = import ../dracula.nix;
in
{
  enable = true;
  style = ''
    * {
        font-family: "FiraCode Nerd Font Propo";
        font-size: 16px;
    }

    window#waybar {
        background-color: ${dracula.black};
        color: ${dracula.lightGrey};
        border: none;
    }

    button {
        /* Avoid rounded borders under each button name */
        border: none;
        border-radius: 0;
    }

    /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
    button:hover {
        background: inherit;
    }

    #network {
      background-color: ${dracula.darkGrey};
    }

    #memory {
      background-color: ${dracula.black};
    }

    #cpu {
      background-color: ${dracula.darkGrey};
    }

    #upower {
      background-color: ${dracula.black};
    }

    /* you can set a style on hover for any module like this */
    #pulseaudio:hover {
        background-color: #a37800;
    }

    #workspaces button {
        padding: 0 5px;
        background-color: transparent;
        color: ${dracula.lightGrey};
    }

    #workspaces button:hover {
        background: rgba(0, 0, 0, 0.2);
    }

    #workspaces button.focused, #workspaces button.active {
        color: ${dracula.black};
        background-color: ${dracula.purple};
    }

    #workspaces button.urgent {
        background-color: #eb4d4b;
    }

    #mode {
        background-color: #64727D;
        box-shadow: inset 0 -3px #ffffff;
    }

    #network,
    #memory,
    #cpu,
    #upower,
    #clock {
        padding: 0 10px;
    }

    #window,
    #workspaces {
        margin: 0 4px;
    }

    /* If workspaces is the leftmost module, omit left margin */
    .modules-left > widget:first-child > #workspaces {
        margin-left: 0;
    }

    /* If workspaces is the rightmost module, omit right margin */
    .modules-right > widget:last-child > #workspaces {
        margin-right: 0;
    }

    #memory.high {
      color: ${dracula.red};
    }

    #memory.medium {
      color: ${dracula.orange};
    }

    #memory.low {
      color: ${dracula.cyan};
    }

    #memory.very-low {
      color: ${dracula.green};
    }
  '';
  settings = [
    {
      position = "top";
      layer = "top";
      "modules-left" = [
        "sway/workspaces"
        "sway/mode"
      ];
      "modules-center" = [ "sway/window" ];
      "modules-right" = [
        "clock"
      ];

      "sway/window" = {
        "max-length" = 50;
      };

      clock = {
        "format" = "{:%R %a %d %b %Y}";
        "tooltip-format" = "<tt><small>{calendar}</small></tt>";
        "calendar" = {
          "mode" = "year";
          "mode-mon-col" = 3;
          "weeks-pos" = "right";
          "on-scroll" = 1;
          "format" = {
            "months" = "<span color='#ffead3'><b>{}</b></span>";
            "days" = "<span color='#ecc6d9'><b>{}</b></span>";
            "weeks" = "<span color='#99ffdd'><b>W{}</b></span>";
            "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
            "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
          };
        };
        "actions" = {
          "on-click-right" = "mode";
          "on-scroll-up" = "tz_up";
          "on-scroll-down" = "tz_down";
        };
      };
    }
    {
      position = "bottom";
      layer = "top";
      "modules-right" = [
        "network"
        "memory"
        "cpu"
        "upower"
      ];

      upower = {
        format = "{percentage}";
        format-alt = "{percentage} {time}";
        icon-size = 20;
        tooltip = true;
        tooltip-spacing = 20;
      };
      memory = {
        interval = 1;
        format = "{used:0.1f}/{total:0.1f}GiB";
        states = {
          high = 70;
          medium = 20;
          low = 10;
          very-low = 0;
        };
      };
      cpu = {
        interval = 1;
        format = "{icon0}{icon1}{icon2}{icon3}{icon4}{icon5}{icon6}{icon7}{icon8}{icon9}{icon10}{icon11}{icon12}{icon13}{icon14}{icon15}";
        format-icons = [
          "<span color='${dracula.green}'>▁</span>"
          "<span color='${dracula.cyan}'>▂</span>"
          "<span color='${dracula.lightGrey}'>▃</span>"
          "<span color='${dracula.lightGrey}'>▄</span>"
          "<span color='${dracula.yellow}'>▅</span>"
          "<span color='${dracula.yellow}'>▆</span>"
          "<span color='${dracula.orange}'>▇</span>"
          "<span color='${dracula.red}'>█</span>"
        ];
      };
      network = {
        interface = "wlp0s20f3";
        format = "{ifname}";
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = "{ipaddr}/{cidr} 󰊗";
        format-disconnected = "disconnected";
        tooltip-format = "{ifname} via {gwaddr} 󰊗";
        tooltip-format-wifi = "{essid} ({signalStrength}%) ";
        tooltip-format-ethernet = "{ifname} ";
        max-length = 50;
      };
    }
  ];
}
