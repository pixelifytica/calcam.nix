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
  version = "2.16.3";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "euratom-software";
    repo = "calcam";
    tag = "${version}";
    hash = "sha256-v5upf8G0YoBmhmPUBvVwuvflQ/3RhO/ytCAZJWL3KwI=";
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
