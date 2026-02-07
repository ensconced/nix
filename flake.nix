{
  description = "Joe's Everything Flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    # r-ryantm auto-update branch for cursor-cli
    nixpkgs-cursor-cli.url = "github:r-ryantm/nixpkgs/auto-update/cursor-cli";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Some things e.g. ghostty unfortunately cannot be installed
    # from nixpkgs on macOS - for these we use homebrew.
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-cursor-cli,
      nix-darwin,
      home-manager,
      sops-nix,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      plasma-manager,
      ...
    }:
    let
      linuxPkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      linuxPkgsUnstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      linuxPkgsCursorCli = import nixpkgs-cursor-cli {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      darwinPkgs = import nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
      darwinPkgsUnstable = import nixpkgs-unstable {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
      darwinPkgsCursorCli = import nixpkgs-cursor-cli {
        system = "aarch64-darwin";
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./common-configuration.nix
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              pkgsUnstable = linuxPkgsUnstable;
              pkgsCursorCli = linuxPkgsCursorCli;
            };
            home-manager.users.joe = {
              imports = [
                ./home/joe/nixos.nix
                ./home/joe/common.nix
              ];
            };
            home-manager.users.catherine = {
              imports = [
                ./home/catherine/common.nix
              ];
            };
            home-manager.backupFileExtension = "backup";
            home-manager.sharedModules = [
              sops-nix.homeManagerModules.sops
              plasma-manager.homeModules.plasma-manager
            ];
          }
          {
            networking.hostName = "thinkpad";
          }
        ];
      };

      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#EL-J5TJLVJ6RK
      darwinConfigurations."EL-J5TJLVJ6RK" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit self;
        };
        modules = [
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              # Install Homebrew under the default prefix
              enable = true;

              # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
              enableRosetta = true;

              # User owning the Homebrew prefix
              user = "joe.barnett";

              # Optional: Declarative tap management
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
              };
              # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
              mutableTaps = false;
            };
          }
          # Optional: Align homebrew taps config with nix-homebrew
          (
            { config, ... }:
            {
              homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
            }
          )
          ./common-configuration.nix
          ./darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              pkgsUnstable = darwinPkgsUnstable;
              pkgsCursorCli = darwinPkgsCursorCli;
            };
            home-manager.backupFileExtension = "backup";
            home-manager.sharedModules = [
              sops-nix.homeManagerModules.sops
            ];
            home-manager.users."joe.barnett" = {
              imports = [
                ./home/joe/darwin.nix
                ./home/joe/common.nix
              ];
            };
          }
        ];
      };

      # devShells to aid development of this repo on either linux or macOS
      devShells."x86_64-linux".default = linuxPkgs.mkShell {
        packages = [
          linuxPkgs.sops
          linuxPkgs.nixfmt-rfc-style # for formatting nix code
        ];
      };
      devShells."aarch64-darwin".default = darwinPkgs.mkShell {
        packages = [
          darwinPkgs.sops
          darwinPkgs.nixfmt-rfc-style
        ];
      };
    };
}
