{
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cython,
  numpy,
  pytest,
  ...
}:
buildPythonPackage rec {
  pname = "triangle";
  version = "20250106";
  pyproject = true;
  src = fetchFromGitHub {
    owner = "drufat";
    repo = "triangle";
    tag = "v${version}";
    hash = "sha256-owXcvQGDcrTvHUNbXJR2ei+gH63/m1h+W7GSNIlRSLo=";
    fetchSubmodules = true;
  };
  build-system = [
    setuptools
    cython
  ];
  dependencies = [ numpy ];
  optional-dependencies = [ pytest ];
  nativeCheckInputs = [ pytest ];
}
