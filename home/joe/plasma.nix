{ pkgs, ... }:

{
  programs.plasma = {
    enable = true;

    # Workspace settings
    workspace = {
      # Theme configuration
      # lookAndFeel = "org.kde.breezedark.desktop";
      # cursor.theme = "Breeze";
      # iconTheme = "Breeze Dark";
      # wallpaper = "${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/Next/contents/images_dark/3840x2160.png";
    };

    # Hotkeys for custom commands
    hotkeys.commands = {
      # Example: launch terminal with Meta+Return
      # "launch-terminal" = {
      #   name = "Launch Terminal";
      #   key = "Meta+Return";
      #   command = "ghostty";
      # };
    };

    # Shortcuts for KDE components
    shortcuts = {
      # Example shortcuts
      # kwin = {
      #   "Switch Window Down" = "Meta+J";
      #   "Switch Window Left" = "Meta+H";
      #   "Switch Window Right" = "Meta+L";
      #   "Switch Window Up" = "Meta+K";
      # };
    };

    # Panel configuration
    # panels = [
    #   {
    #     location = "bottom";
    #     height = 44;
    #     widgets = [
    #       "org.kde.plasma.kickoff"
    #       "org.kde.plasma.pager"
    #       "org.kde.plasma.icontasks"
    #       "org.kde.plasma.marginseparator"
    #       "org.kde.plasma.systemtray"
    #       "org.kde.plasma.digitalclock"
    #     ];
    #   }
    # ];

    # Input settings
    # input.keyboard = {
    #   numlockOnStartup = "on";
    # };
  };
}
