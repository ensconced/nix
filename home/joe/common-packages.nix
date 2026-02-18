{
  pkgs,
  pkgsUnstable,
  pkgsCursorCli,
  ...
}:
{
  home.packages =
    let
      scripts = import ./scripts.nix { inherit pkgs pkgsUnstable; };
    in
    [
      pkgs.spotify-player
      pkgs.tree
      pkgs.jq
      pkgs.nixfmt-rfc-style
      pkgs.timg
      pkgs.pstree
      pkgs.fnm
      pkgs.pnpm_9
      pkgs.ripgrep
      pkgs.fd
      pkgs.graphviz
      pkgsUnstable.postgresql_18 # for psql
      pkgsCursorCli.cursor-cli # for cursor-agent
      pkgsUnstable.awscli2

      # language servers etc
      pkgs.prettierd
      pkgs.eslint_d
      pkgs.terraform
      pkgs.lua-language-server # useful for this repo but also any other repo where I use an .nvim.lua
      pkgs.typescript-language-server # provides LSP for TS in neovim
      pkgs.vscode-langservers-extracted # HTML/CSS/JSON/ESLint language servers extracted from vscode
    ]
    ++ scripts;
}
