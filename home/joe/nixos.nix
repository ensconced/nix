{
  config,
  pkgs,
  pkgsUnstable,
  lib,
  ...
}:

{
  imports = [
    ./aws.nix
    ./common-packages.nix
    ./plasma.nix
  ];

  home.username = "joe";
  home.homeDirectory = "/home/joe";

  home.file.".dmrc".text = ''
    [Desktop]
    Session=sway
  '';

  home.packages = import ./packages.nix {
    inherit pkgs;
    inherit pkgsUnstable;
  };
  programs.wofi.enable = true;

  programs.ghostty.enable = true;
  xdg.configFile.ghostty-config = {
    text = import ./ghostty.nix { inherit pkgs; };
    target = "./ghostty/config";
  };
  home.file.repoconf = {
    source = ./repoconf;
    target = "./.repoconf";
    force = true;
  };

  wayland.windowManager.sway.enable = true;
  # I handle the systemd setup for sway myself, so that I can
  # ensure that it only starts once xremap is ready.
  wayland.windowManager.sway.systemd.enable = false;
  systemd.user.targets.sway-session = {
    Unit = {
      Description = "sway compositor session";
      Documentation = [ "man:systemd.special(7)" ];
      Requires = [
        "xremap.service"
      ];
      Before = [
        "xremap.service"
      ];
    };
  };

  xdg.configFile.sway-config = {
    text = import ./sway-config.nix { inherit pkgs; };
    target = "./sway/config";
  };

  xdg.configFile.spotify-player-config = {
    source = ./spotify-player-config.toml;
    target = "./spotify-player/app.toml";
  };
  xdg.configFile.nvim-config = {
    source = ./neovim/init.lua;
    target = "./nvim/init.lua";
  };
  home.file.git-config = {
    source = ./personal-git-config;
    target = "./.config/git/config";
  };
  programs.waybar = import ./waybar { inherit lib; };
  sops = {
    age.sshKeyPaths = [ "/home/joe/.ssh/id_ed25519" ];
    defaultSopsFile = ./secrets/main.yaml;
    secrets.aws-credentials = {
      sopsFile = ./secrets/aws-credentials.ini;
      format = "ini";
      key = ""; # emit whole file
      path = "${config.home.homeDirectory}/.aws/credentials";
    };
  };
}
