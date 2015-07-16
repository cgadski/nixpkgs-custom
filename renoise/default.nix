{ stdenv, requireFile, demo ? true, fetchurl, makeConfortable, ... }:

let
 
  rns-installer = 
    fetchurl {
      url = "http://files.renoise.com/demo/Renoise_3_0_1_Demo_x86_64.tar.bz2";
      sha256 = "1q7f94wz2dbz659kpp53a3n1qyndsk0pkb29lxdff4pc3ddqwykg";
    };
 
  renoise =
    stdenv.mkDerivation {
      name = "renoise";  phases = "unpackPhase installPhase";
      unpackPhase = "tar -xf $src";

      src =
        aseert builtins.currentSystem == "x86_64-linux";
        if demo then rns-installer
        else
          requireFile {
            url = "http://backstage.renoise.com/frontend/app/index.html#/login";
            name = "rns_3_0_1_linux_x86_64.tar.gz";
            sha256 = "0n23m0f3pkwgicgvvg4hr7wa1jdk0py91fndda5986ri0km4j6af";
          }

      installPhase = ''
        ${if demo then "cd Renoise_3_0_1_Demo_x86_64" else ""}

        mkdir -p $out/ ; cp -r ./Resources/* $out/
        mkdir -p $out/lib/ ; mv $out/AudioPluginServer_x86_64 $out/lib/
        cp renoise $out/renoise
      '';
    };
in
  makeConfortable {
    deriv = renoise;
    bin = "renoise";
    resources = "lib";
  }
