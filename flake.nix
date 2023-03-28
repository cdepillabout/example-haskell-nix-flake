{
  description = "Example Nix Flake for Haskell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { flake-utils, nixpkgs, self }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          config = {};
          overlays = [
            (final: prev: {
              myHaskellPackages = final.haskell.packages.ghc924.override {
                overrides = hfinal: hprev: {
                  example-haskell-nix-flake = hfinal.callCabal2nix "example-haskell-nix-flake" ./. {};
                };
              };

              example-haskell-nix-flake =
                final.haskell.lib.compose.justStaticExecutables
                  final.myHaskellPackages.example-haskell-nix-flake;

              myDevShell = final.myHaskellPackages.shellFor {
                packages = p: [ p.example-haskell-nix-flake ];

                nativeBuildInputs = [
                  final.cabal-install
                  final.haskell.packages.ghc924.haskell-language-server
                ];
              };
            })
          ];
          pkgs = import nixpkgs { inherit config overlays system; };
        in
        {
          packages.default = pkgs.example-haskell-nix-flake;

          devShell.default = pkgs.myDevShell;
        }
      );
}
