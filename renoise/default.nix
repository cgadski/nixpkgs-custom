{ stdenv, requireFile, demo ? true, fetchurl, makeConfortable, ... }:

let
  renoise =
    stdenv.mkDerivation {
      name = "renoise";

      phases = "unpackPhase installPhase";

      src =
        if demo then
          fetchurl {
            url = "http://files.renoise.com/demo/Renoise_3_0_1_Demo_x86_64.tar.bz2";
            sha256 = "1q7f94wz2dbz659kpp53a3n1qyndsk0pkb29lxdff4pc3ddqwykg";
          }
        else
          if builtins.currentSystem == "x86_64-linux" then
            requireFile {
              url = "http://backstage.renoise.com/frontend/app/index.html#/login";
              name = "rns_3_0_1_linux_x86_64.tar.gz";
              sha256 = "0n23m0f3pkwgicgvvg4hr7wa1jdk0py91fndda5986ri0km4j6af";
            }
          else throw "haven't written this for systems besides 64-bit linux";

      unpackPhase = ''
        tar -xf $src
      '';

      installPhase = ''
        cd ${if demo then "Renoise_3_0_1_Demo_x86_64" else ""}

        mkdir -p $out/
        cp -r ./Resources/* $out/
        mkdir -p $out/lib/
        mv $out/AudioPluginServer_x86_64 $out/lib/
        cp renoise $out/renoise
      '';
    };
in
  makeConfortable {
    deriv = renoise;
    bin = "renoise";
    resources = "lib";
  }

