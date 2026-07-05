{
  description = "Lore is a next generation open source version control system originally designed and built by Epic Games.";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      perSystem = { config, pkgs, ... }: {
        packages = {
          default = config.packages.lore-vcs;
          lore-vcs = pkgs.callPackage ./package.nix { };
        };
      };
      flake = {
        nixosModules = {
          default = ./service.nix;
          loreserver = import ./service.nix;
        };
        overlays = {
          default = final: prev: {
            lore = final.callPackage ./package.nix;
          };
        };
      };
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
        "aarch64-linux"
      ];
    };
}
