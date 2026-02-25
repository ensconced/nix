{
  description = "Flake for local development of elliptic-frontend";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      system = "aarch64-darwin";
    in
    {
      devShells."${system}".default =
        let
          pkgs = import nixpkgs { inherit system; };
        in
        pkgs.mkShell {
          name = "devshell";
          buildInputs = [
            # all required for building canvas npm package
            pkgs.pkg-config
            pkgs.pixman
            pkgs.python314
            pkgs.cairo
            pkgs.pango
            pkgs.libpng
            pkgs.libjpeg
            pkgs.giflib
            pkgs.librsvg
          ];
        };
    };
}
