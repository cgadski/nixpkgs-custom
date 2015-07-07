{ pkgs ? import <nixpkgs> {}, ... }:
{deriv, modifier}:

with pkgs;

stdenv.mkDerivation {
  name = deriv.name;
  src = deriv;

  phases = "installPhase";
  installPhase = ''
    mkdir ./base/
    cp -r $src/* ./base/
    ${modifier};
    for f in $(find . -type f); do
      substituteInPlace $f --replace $src $out
    done;
    mkdir -p $out
    cp -r ./base/* $out
  '';
}

