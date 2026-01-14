{
  outputs =
    { self, nixpkgs, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
      ];
      supportedPythons = [
        "python310"
        "python311"
        "python312"
        "python313"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: (nixpkgs.legacyPackages.${system}.extend self.overlays.default));
    in
    {
      overlays = {
        default = (
          final: prev:
          {
            calcam =
              let
                python3 = (final.python3.withPackages (ps: [ ps.calcam ]));
              in
              final.symlinkJoin {
                name = "calcam";
                paths = [
                  python3
                  (python3.pkgs.toPythonApplication python3.pkgs.calcam)
                ];
                buildInputs = [
                  final.libsForQt5.wrapQtAppsHook
                  final.libsForQt5.qtbase
                  final.libsForQt5.qtwayland
                ];
                postBuild = ''
                  wrapQtApp $out/bin/calcam
                '';
              };
          }
          // (builtins.listToAttrs (
            map (name: {
              inherit name;
              value = prev.${name}.override {
                packageOverrides = pfinal: pprev: {
                  triangle = pfinal.callPackage ./triangle.nix { };
                  calcam = pfinal.callPackage ./calcam.nix { };
                };
              };
            }) supportedPythons
          ))
        );
      };
      packages = forAllSystems (system: {
        inherit (pkgs.${system}) calcam;
        default = self.packages.${system}.calcam;
      });
      devShells = forAllSystems (system: {
        default = pkgs.${system}.mkShellNoCC {
          packages = [
            (pkgs.${system}.python3.withPackages (ps: [ ps.calcam ]))
            pkgs.${system}.calcam
          ];
        };
      });
    };
}
