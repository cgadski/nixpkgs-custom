{ pkgs ? import <nixpkgs> {} }:
let
  makeConfortable = import ./makeConfortable.nix {inherit pkgs;};
  modDerivation = import ./modDerivation.nix {inherit pkgs;};
  callMyPackage = x: pkgs.callPackage (x + "/default.nix") {inherit makeConfortable modDerivation;};
in
{
  tib = callMyPackage ./tib;
  renoise = callMyPackage ./renoise;
  continuum = callMyPackage ./continuum;
}
