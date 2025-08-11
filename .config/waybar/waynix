{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: {
  options = {
    waybar.enable = lib.mkEnableOption "enable waybar";
  };

  config = lib.mkIf config.waybar.enable {
    programs.waybar = {
      enable = true;
      style = with config.lib.stylix.colors.withHashtag;
        ''
          @define-color base00 ${base00}; @define-color base01 ${base01}; @define-color base02 ${base02}; @define-color base03 ${base03};
          @define-color base04 ${base04}; @define-color base05 ${base05}; @define-color base06 ${base06}; @define-color base07 ${base07};

          @define-color base08 ${base08}; @define-color base09 ${base09}; @define-color base0A ${base0A}; @define-color base0B ${base0B};
          @define-color base0C ${base0C}; @define-color base0D ${base0D}; @define-color base0E ${base0E}; @define-color base0F ${base0F};
        ''
        + builtins.readFile ../../extraconfs/os/waybar-style.css;
      settings = {
        bar = {
          # Set position
          layer = "bottom";
          position = "top";
          height = 40;
          spacing = 8;
          # Set margins
          margin-top = 6;
          margin-left = 8;
          margin-right = 8;
          # Set modules
          modules-left = ["hyprland/workspaces" "sway/workspaces"];
          modules-center = ["clock"];
          modules-right = ["tray" "pulseaudio" "bluetooth" "network"];
          # Workspaces
          "hyprland/workspaces" = {
            "disable-scroll" = true;
            "all-outputs" = false;
            "format" = "{icon}";
            "format-icons" = {
              "1" = "";
              "2" = "";
              "3" = "󰈹";
              "4" = "";
              "5" = "󰍳";
              "6" = "󱞁";
              "7" = "󰽰";
              "8" = "";
              "9" = "";
            };
            "on-click" = "activate";
          };
          "sway/workspaces" = {
            "disable-scroll" = true;
            "all-outputs" = false;
            "format" = "{icon}";
            "format-icons" = {
              "1" = "";
              "2" = "";
              "3" = "󰈹";
              "4" = "";
              "5" = "󰍳";
              "6" = "󱞁";
              "7" = "󰽰";
              "8" = "";
              "9" = "";
            };
            "on-click" = "activate";
          };
          # Modules
          "tray" = {
            icon-size = 24;
            spacing = 10;
          };
          "clock" = {
            format = "{:%a %d %b %H:%M}";
          };
          "network" = {
            format-wifi = "{essid} ";
            format-ethernet = "{ifname} = {ipaddr}/{cidr} ";
            format-disconnected = "Disconnected ⚠";
            on-click = "kitty --detach --class floating nmtui";
          };
          "pulseaudio" = {
            format = " {volume}%";
            format-bluetooth = " {volume}%";
            format-muted = "";
            on-click = "kitty --detach --class floating pulsemixer";
          };
          "bluetooth" = {
            format = "";
            on-click = "blueman-manager";
          };
        };
      };
    };
  };
}
