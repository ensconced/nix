{
  pkgs,
  pkgsUnstable,
  config,
  ...
}:
{
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish = import ./fish.nix { inherit pkgs; };
  programs.direnv.enable = true;

  programs.neovim.enable = true;
  programs.neovim.package = pkgsUnstable.neovim-unwrapped;
  programs.neovim.defaultEditor = true;
  programs.neovim.viAlias = true;
  programs.neovim.vimAlias = true;
  programs.neovim.vimdiffAlias = true;
  programs.neovim.plugins = with pkgsUnstable.vimPlugins; [
    dracula-nvim
    mini-nvim
    conform-nvim
    nvim-lspconfig
    git-blame-nvim
    multicursor-nvim
    typescript-tools-nvim
    nvim-metals
  ];

  home.sessionVariables = {
    RIPGREP_CONFIG_PATH = "${config.home.homeDirectory}/.config/ripgrep/config";
    SOPS_AGE_KEY_FILE = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
  };
  home.file.ripgrep-config = {
    text = ''
      # My main use of ripgrep is via the Mini.pick nvim plugin.
      # I generally want it to include hidden files in its search.
      --hidden
    '';
    target = "./.config/ripgrep/config";
  };
}
