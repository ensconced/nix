{
  description = "Flake for local development of shatners-bassoon";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Provides sbt version 1.9.9 as specified in project/build.properties
    nixpkgsForSbt.url = "github:nixos/nixpkgs/e89cf1c932006531f454de7d652163a9a5c86668";
  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgsForSbt,
    }:
    let
      system = "aarch64-darwin";
    in
    {
      devShells."${system}".default =
        let
          pkgs = import nixpkgs { inherit system; };
          pkgsForSbt = import nixpkgsForSbt { inherit system; };
        in
        pkgs.mkShell {
          name = "devshell";

          buildInputs = [
            # I'm not sure if we actually need the two different versions of java??
            pkgs.jdk11_headless
            pkgs.jdk17_headless
            pkgs.metals
            pkgsForSbt.sbt
          ];

          # Not sure if this is actually necessary...
          shellHook = ''
            export JAVA_HOME="${pkgs.jdk17_headless}"
          '';
        };
    };
}
