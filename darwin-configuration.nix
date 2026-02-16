{ pkgs, self, ... }:
{
  # As Determinate manages the Nix installation itself, we need to set nix.enable = false;
  # to disable nix-darwin’s own Nix management.
  # Some nix-darwin functionality that relies on managing the Nix installation,
  # like the nix.* options to adjust Nix settings or configure a Linux builder, will be unavailable.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  system.primaryUser = "joe.barnett";

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users."joe.barnett".home = "/Users/joe.barnett";
  users.users."joe.barnett".shell = pkgs.fish;

  homebrew.enable = true;
  homebrew.brews = [ ];
  homebrew.casks = [
    "ghostty"
    "zoom"
    "slack"
    "rectangle"
    "spotify"
    "dbeaver-community"
  ];

  system.defaults.NSGlobalDomain.AppleShowAllFiles = true;
  system.defaults.NSGlobalDomain.AppleShowScrollBars = "WhenScrolling";
  system.defaults.NSGlobalDomain.NSAutomaticWindowAnimationsEnabled = false;
}
