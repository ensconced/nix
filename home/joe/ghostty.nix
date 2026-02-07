{ pkgs }:
let
  baseConfig = ''
    command = ${pkgs.fish}/bin/fish --login --interactive
    shell-integration = fish
    font-family = IosevkaTerm Nerd Font Mono
    font-size = 18
    theme = Dracula
    macos-option-as-alt = left
  '';
  linuxConfig = baseConfig + ''
    keybind = alt+c=copy_to_clipboard
    keybind = alt+v=paste_from_clipboard
  '';
in
if pkgs.stdenv.isLinux then linuxConfig else baseConfig
