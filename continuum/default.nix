{ stdenv, fetchurl, wine, writeScript, ... }:

let
  installer =
    fetchurl {
      url = "http://www.getcontinuum.com/downloads/continuum/Continuum040Setup.exe";
      sha256 = "0gkh7shsk1zy7dyj2g2s5qhsjj10p6chxsrbnwsdx3rzwiaa6y2z";
    };
  
  patched-wine =
    wine.overrideDerivation (attrs: {
      patches = [./patch.diff];
    });

in

{
  install = 
    writeScript "continuum-install" ''
      ${wine}/bin/wine ${installer}
    '';

  game = 
    writeScript "continuum" ''
      ${patched-wine}/bin/wine ~/.wine/drive_c/Program\ Files\ \(x86\)/Continuum/Continuum.exe
    '';
}
