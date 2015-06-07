{ pkgs ? import <nixpkgs> {} }:
let
  makeConfortable = import ./makeConfortable.nix {inherit pkgs;};
  callMyPackage = x: pkgs.callPackage (x + "/default.nix") {inherit makeConfortable;};
in
{
  tib = callMyPackage ./tib;
  renoise = callMyPackage ./renoise;
}
