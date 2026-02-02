{
  stdenv,
  python3,
  qtbase,
  qtwayland,
  wrapQtAppsHook,
  useQt6 ? false,
  vtk,
  vtkWithQt6,
  ...
}:
let
  pythonWithCalcam = (
    (python3.override {
      packageOverrides = (
        pfinal: pprev: {
          triangle = pfinal.callPackage ./triangle.nix { };
          calcam = pfinal.callPackage ./calcam-lib.nix { inherit useQt6; };
        }
      );
    }).withPackages
      (ps: [ ps.calcam ])
  );
in
stdenv.mkDerivation {
  inherit (python3.pkgs.calcam) pname version;
  src = pythonWithCalcam.out;
  buildInputs = [
    pythonWithCalcam.pkgs.calcam
    qtbase
    qtwayland
  ]
  ++ (if useQt6 then [ vtkWithQt6 ] else [ vtk ]);
  nativeBuildInputs = [
    wrapQtAppsHook
  ];
  installPhase = ''
    mkdir -p $out/
    cp -R * $out/
    for file in $out/bin/*; do wrapProgram "$file" --prefix QT_QPA_PLATFORM : "xcb"; done
  '';
}
