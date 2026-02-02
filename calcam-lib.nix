{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  scipy,
  matplotlib,
  vtk,
  opencv-python-headless,
  h5py,
  triangle,
  useQt6 ? false,
  pyqt5,
  pyqt6,
  ...
}:
buildPythonPackage rec {
  pname = "calcam";
  version = "2.16.2";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "euratom-software";
    repo = "calcam";
    tag = "${version}";
    hash = "sha256-/OadKEdAIJBcRvbsSwR9KLMc8HdzUX24pxt6+byOXGI=";
  };
  dontCheckRuntimeDeps = useQt6;
  build-system = [ setuptools ];
  dependencies = [
    scipy
    matplotlib
    vtk
    opencv-python-headless
    h5py
    triangle
  ]
  ++ (if useQt6 then [ pyqt6 ] else [ pyqt5 ]);
}
