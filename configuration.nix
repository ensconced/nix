# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # used to save secrets e.g. wifi psks. without this, I'd have to re-enter the wifi
  # password after resuming from sleep
  services.gnome.gnome-keyring.enable = true;
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  # allow flashing qmk keyboard without using sudo - https://docs.qmk.fm/faq_build#can-t-program-on-linux
  services.udev.extraRules = (builtins.readFile ./udevrules/qmk);

  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # The command-not-found utility doesn't really work
  # if you're using flakes
  programs.command-not-found.enable = false;

  services.xserver.enable = true; # optional
  services.xserver.xkb.layout = "gb";
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure console keymap
  console.keyMap = "uk";
  console.earlySetup = true;
  console.packages = [ pkgs.kbd ];

  services.printing.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # used by waybar
  services.upower.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.joe = {
    isNormalUser = true;
    description = "Joe Barnett";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  users.users.catherine = {
    isNormalUser = true;
    description = "Catherine Wood";
  };

  # required for loads of npm packages that include prebuilt binaries
  # to work correctly
  programs.nix-ld.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # pulseaudio is installed here just to be able to use pactl,
    # which will be running against pipewire's pulseaudio server
    # emulation.
    pulseaudio

    bluetui

    inotify-tools

  ];

  # these options don't exist for nix-darwin
  documentation.dev.enable = true;
  documentation.man.generateCaches = true;
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
