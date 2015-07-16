{ stdenv, fetchurl, unzip, makeConfortable, ... }:

let
  tib = 
    stdenv.mkDerivation rec {
      name = "the-infinite-black";

      src = 
        assert stdenv.system == "x86_64-linux";
        fetchurl {
          url = "https://files.spellbook.com/download/tib-unity-linux.zip";
          sha256 = "0cahbbw5d4fg6wirsckcjfwbzgsfb7g1dxngw95ldcdakj7pj5la";
        };

      phases = "unpackPhase installPhase";
      buildInputs = [unzip]; unpackPhase = "unzip $src";

      installPhase = ''
        mkdir -p $out/lib/
        cp -r tib-unity-linux_Data $out/
        cp ./tib-unity-linux.x86_64 $out/
      '';
    };
in
  makeConfortable { 
      deriv = tib;
      bin = "tib-unity-linux.x86_64";
      resources = "lib";
  }   
