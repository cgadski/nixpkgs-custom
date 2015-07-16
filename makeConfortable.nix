{ pkgs ? import <nixpkgs> {}, ... }:
# mkConfortable is useful for getting a third-party pre-packaged
# binary and set of resources and getting it to work in nix;
# it additionally loads a set of libraries that one generally assumes
# are already present on a end-user system, for minimum hassle

# deriv: the base derivation
# bin: the target binary's filepath, relative to the derivation root
# resources: the target resource filepath
{deriv, bin, resources}:

with pkgs.stdenv.lib;

let
  unlines = strs: concatStrings ((map (x: x + "\n")) strs);

  newDeriv = {stdenv, mesa_glu, libX11, libXext, libXcursor, libXrandr, gcc, alsaLib}:
    stdenv.mkDerivation rec {
      inherit (deriv) name;
      src = deriv; phases = "installPhase";
      libs = [mesa_glu libX11 libXext libXcursor libXrandr alsaLib stdenv.cc.cc];
      inherit resources bin;

      installPhase = ''
        # copy source tree, fill up resources
        mkdir -p $out/$resources
        ${unlines (map (lib: "ln -s ${lib}/lib/*.so* $out/$resources/") libs)}
        cp -r $src/* $out/
        patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath $out/$resources $out/$bin
      '';
    };
in pkgs.callPackage newDeriv {}
