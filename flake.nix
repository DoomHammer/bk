{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };
  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlays = [ (import rust-overlay) ];
          pkgs = import nixpkgs {
            inherit system overlays;
          };
        in
        with pkgs;
        {
        packages.sheldon = pkgs.callPackage ./bk.nix {
            inherit (pkgs.darwin.apple_sdk.frameworks) Security;
          };
        packages.default = self.outputs.packages.${system}.sheldon;
        defaultPackage = self.packages.${system}.sheldon;
          devShells.default = mkShell {
            buildInputs = [ rust-bin.stable.latest.default ];
          };
        }
      );
}
