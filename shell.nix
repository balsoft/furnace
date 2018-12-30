{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, aeson, base, blaze-html, bytestring
      , containers, http-types, monad-logger, persistent
      , persistent-postgresql, persistent-sqlite, persistent-template
      , resourcet, scotty, stdenv, text, time, transformers, wai
      , wai-extra, wai-middleware-static, warp, hpc-coveralls
      }:
      mkDerivation {
        pname = "furnace";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = false;
        isExecutable = true;
        
        executableHaskellDepends = [
          aeson base blaze-html bytestring containers http-types monad-logger
          persistent persistent-postgresql persistent-sqlite
          persistent-template resourcet (pkgs.haskell.lib.dontCheck scotty) text time transformers wai
          wai-extra wai-middleware-static warp pkgs.cabal-install
        ];
        shellHook = "cabal v1-run;exit $?";
        license = "GPL";
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
