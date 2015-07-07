{ stdenv, writeScript, fetchurl, wine, replaceDependency, ... }:

let
  win-installer =
    fetchurl {
      url = "http://www.getcontinuum.com/downloads/continuum/Continuum040Setup.exe";
      sha256 = "0gkh7shsk1zy7dyj2g2s5qhsjj10p6chxsrbnwsdx3rzwiaa6y2z";
    };

  patched-kernel =
    fetchurl {
      url = "http://subspace2.net/kernel32.dll.so";
      sha256 = "0myv8sgiz3b4xj2vrnvkwpl8mzsf3r68y1fn790hcpz6rsn6bh2j";
    };

  patched-wine = stdenv.mkDerivation {
    name = wine.name; phases = "installPhase";
    installPhase = ''
      mkdir -p $out; cp -r ${wine}/* $out
      rm $out/lib/wine/kernel32.dll.so
      cp ${patched-kernel} $out/lib/wine/kernel32.dll.so
    '';
    };

  linked-wine = 
    replaceDependency {
      drv = patched-wine;
      oldDependency = wine;
      newDependency = patched-wine;
    };

  installer = 
    writeScript "continuum-install"
      ''
        ${wine}/bin/wine ${win-installer}
      '';

  game =
    writeScript "continuum"
      ''
        ${linked-wine}/bin/wine ~/.wine/drive_c/Program\ Files\ \(x86\)/Continuum/Continuum.exe
      '';
 
in

{ inherit installer patched-wine; } 
