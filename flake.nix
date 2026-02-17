{
  outputs =
    { self, nixpkgs, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgs = forAllSystems (system: (nixpkgs.legacyPackages.${system}.extend self.overlays.default));
    in
    {
      overlays.default = final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (pfinal: pprev: {
            triangle = pfinal.callPackage ./triangle.nix { };
            calcam = pfinal.callPackage ./calcam-lib.nix { };
          })
        ];
        calcam-qt5 = final.libsForQt5.callPackage ./calcam-gui.nix { useQt6 = false; };
        calcam-qt6 = final.qt6Packages.callPackage ./calcam-gui.nix { useQt6 = true; };
        calcam = final.calcam-qt6;
      };
      packages = forAllSystems (system: {
        inherit (pkgs.${system}) calcam-qt5 calcam-qt6 calcam;
        default = self.packages.${system}.calcam;
      });
      devShells = forAllSystems (system: {
        default =
          let
            inherit (pkgs.${system}) mkShellNoCC python3;
          in
          mkShellNoCC {
            packages = [
              self.packages.${system}.calcam
              (python3.withPackages (ps: [ ps.calcam ]))
            ];
          };
      });
    };
}
