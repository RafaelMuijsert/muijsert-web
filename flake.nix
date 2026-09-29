{
  description = "Personal Website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        website = pkgs.stdenvNoCC.mkDerivation {
          pname = "personal-website";
          version = "0.1.0";

          src = ./.;

          nativeBuildInputs = [
            pkgs.hugo
          ];

          buildPhase = ''
            hugo --minify
          '';

          installPhase = ''
            cp -r public $out
          '';
        };

        default = self.packages.${system}.website;
      }
    );
  };
}
