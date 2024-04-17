{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  beautifulsoup4,
  python-doi,
  requests,
}:
buildPythonPackage rec {
  pname = "scihub";
  version = "unstable-2019-04-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alejandrogallo";
    repo = "python-scihub";
    rev = "130200ce038632980597f38c19424c9c363a60a0";
    hash = "sha256-FvddCQX4zKdO9gBZiCJblWPBxch4pvnS4MAPwYP4hKw=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    python-doi
    requests
  ];

  pythonImportsCheck = ["scihub"];

  meta = with lib; {
    description = "Python API and command-line tool for Sci-hub";
    homepage = "https://github.com/alejandrogallo/python-scihub";
    license = licenses.mit;
    maintainers = with maintainers; [vinnymeller];
  };
}
