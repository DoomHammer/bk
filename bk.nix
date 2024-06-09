# bk package definition
#
# This file will be similar to the package definition in nixpkgs:
#     https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/bk/bk/package.nix
#
# Helpful documentation: https://github.com/NixOS/nixpkgs/blob/master/doc/languages-frameworks/rust.section.md
{
  pkgs,
  lib,
  stdenv,
  installShellFiles,
  rustPlatform,
  Security,
}:
rustPlatform.buildRustPackage {
  name = "bk";

  src = lib.cleanSource ./.;

  cargoLock = {
    lockFile = ./Cargo.lock;
    # Allow dependencies to be fetched from git and avoid having to set the outputHashes manually
    allowBuiltinFetchGit = true;
  };

  nativeBuildInputs = [installShellFiles];

  buildInputs = lib.optionals stdenv.isDarwin [Security];

  doCheck = false;

  meta = with lib; {
    description = "Terminal Epub reader";
    homepage = "https://github.com/aeosynth/bk";
    license = licenses.mit;
    mainProgram = "bk";
  };
}
