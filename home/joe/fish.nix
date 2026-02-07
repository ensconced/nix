{ pkgs, ... }:
{
  enable = true;
  shellInit =
    let
      commonConfig = ''
        if [ -n "$GHOSTTY_RESOURCES_DIR" ];
            builtin source "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
        end
        set -g fish_greeting
        fish_config theme choose Dracula
      '';
      linuxConfig = commonConfig + ''
        alias cpy wl-copy
        alias pst wl-paste
      '';
      macOSConfig = commonConfig + ''
        alias cpy pbcopy
        alias pst pbpaste
      '';
    in
    if pkgs.stdenv.isLinux then linuxConfig else macOSConfig;
  # Load scala-cli completions when it becomes available (e.g. via direnv/nix shell).
  # Watches PATH changes and runs once per session.
  interactiveShellInit = ''
    function __scala_cli_completions_hook --on-variable PATH
        if command -q scala-cli; and not set -q __scala_cli_completions_loaded
            eval (scala-cli install completions --env --shell fish)
            set -g __scala_cli_completions_loaded 1
        end
    end
  '';
}
