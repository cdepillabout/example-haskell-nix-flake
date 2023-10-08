{
  description = "Example Nix Flake for Haskell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
  };

  outputs = {
    nixpkgs,
    self,
  }: let
    overlay = final: prev: {
      haskellPackages = prev.haskellPackages.override {
        overrides = hfinal: hprev: {
          example-haskell-nix-flake =
            hfinal.callCabal2nix "example-haskell-nix-flake" ./. {};
        };
      };

      example-haskell-nix-flake =
        final.haskell.lib.compose.justStaticExecutables
        final.haskellPackages.example-haskell-nix-flake;
    };

    forEachSystem = f:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ] (system:
        f (import nixpkgs {
          inherit system;
          overlays = [overlay];
        }));
  in {
    overlays.default = overlay;

    packages = forEachSystem (pkgs: {
      default = pkgs.example-haskell-nix-flake;
    });

    devShells = forEachSystem (pkgs: {
      default = pkgs.haskellPackages.shellFor {
        packages = ps: [ps.example-haskell-nix-flake];

        nativeBuildInputs = [
          pkgs.cabal-install
          pkgs.haskellPackages.haskell-language-server
        ];
      };
    });
  };
}
