{
  inputs = {
    cargo2nix.url = "github:cargo2nix/cargo2nix/master";
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:nixos/nixpkgs?ref=release-21.11";
  };

  outputs = { self, nixpkgs, cargo2nix, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [cargo2nix.overlay];
        };

        rustPkgs = pkgs.rustBuilder.makePackageSet {
          rustVersion = "1.60.0";
          packageFun = import ./Cargo.nix;
        };

      in rec {
        packages = {
          # replace hello-world with your package name
          hello-world = (rustPkgs.workspace.wgpu-triangle {}).bin;
        };
        defaultPackage = packages.hello-world;
      }
    );
}