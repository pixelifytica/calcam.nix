{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  scipy,
  matplotlib,
  vtk,
  pyqt5,
  opencv-python-headless,
  h5py,
  triangle,
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
  build-system = [ setuptools ];
  dependencies = [
    scipy
    matplotlib
    vtk
    pyqt5
    opencv-python-headless
    h5py
    triangle
  ];
}
