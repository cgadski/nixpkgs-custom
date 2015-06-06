{pkgs ? import <nixpkgs> {}}:

with pkgs.stdenv.lib;

let
  unlines = strs: concatStrings ((map (x: x + "\n")) strs);

  tib = {stdenv, fetchurl, unzip, mesa_glu, libX11, libXext, libXcursor, libXrandr, gcc}:
    stdenv.mkDerivation rec {
      name = "the-infinite-black";

      src = 
        if stdenv.system == "x86_64-linux"
          then
            fetchurl {
              url = "https://files.spellbook.com/download/tib-unity-linux.zip";
              sha256 = "0qy5nly3vkvlzm32w85j1bn7x1qs49kx2nmlyp1pq1xnn70b2zny";
            }
          else throw "incompatible system";

      phases = "unpackPhase installPhase";

      unpackPhase = ''
        unzip $src
      '';

      libs = [mesa_glu libX11 libXext libXcursor libXrandr];

      installPhase = ''
        mkdir -p $out/lib/

        patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) --set-rpath $out/lib/ ./tib-unity-linux.x86_64

        # resources
        ${unlines (map (lib: "cp -r ${lib}/lib/*.so* $out/lib") libs)}
        cp /nix/store/2q4nir7g03b7qidk9m2r9wcq3ga1fv65-gcc-4.8.4/lib64/libstdc++.so.6 $out/lib
        cp -r tib-unity-linux_Data $out/

        # bin
        cp ./tib-unity-linux.x86_64 $out/
      '';

      buildInputs = [unzip];

      meta =
        { 
          description = "Interesting, free (as in free beer) and very active space-based MMO.";
        };
    };
in
  pkgs.callPackage tib {}
