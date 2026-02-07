{ config, pkgs, ... }:
{

  time.timeZone = "Europe/London";

  programs.fish.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  environment.systemPackages = with pkgs; [
    # programming things
    git

    # documentation
    man-pages
    man-pages-posix

    # other
    wget
    killall
    unzip
  ];

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  documentation.doc.enable = true;
  documentation.info.enable = true;
  documentation.man.enable = true;
}
