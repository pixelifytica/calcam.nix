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
            calcam-qt5 = final.libsForQt5.callPackage ./calcam-gui.nix { useQt6 = false; };
            calcam-qt6 = final.qt6Packages.callPackage ./calcam-gui.nix { useQt6 = true; };
            calcam = final.calcam-qt6;
          }
          // (builtins.listToAttrs (
            map (name: {
              inherit name;
              value = prev.${name}.override {
                packageOverrides = pfinal: pprev: {
                  triangle = pfinal.callPackage ./triangle.nix { };
                  calcam = pfinal.callPackage ./calcam-lib.nix { };
                };
              };
            }) supportedPythons
          ))
        );
      };
      packages = forAllSystems (system: {
        inherit (pkgs.${system}) calcam-qt5 calcam-qt6 calcam;
        default = self.packages.${system}.calcam;
      });
      devShells = forAllSystems (system: {
        default =
          let
            inherit (pkgs.${system}.qt6Packages) qtbase;
          in
          pkgs.${system}.mkShellNoCC {
            env.QT_QPA_PLATFORM_PLUGIN_PATH = "${qtbase.bin}/lib/qt-${qtbase.version}/plugins";
            packages = [ (pkgs.${system}.python3.withPackages (ps: [ ps.calcam ])) ];
          };
      });
    };
}
