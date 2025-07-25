{
  lib,
  buildPythonPackage,
  docutils,
  fetchPypi,
  flit-core,
  jinja2,
  pythonOlder,
  requests,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-confluencebuilder";
  version = "2.13.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "sphinxcontrib_confluencebuilder";
    inherit version;
    hash = "sha256-2Sl0ZwdHn0dXf+kbNcxaDMfWLaGdfUgCRjKTADA+unM=";
  };

  build-system = [ flit-core ];

  dependencies = [
    docutils
    sphinx
    requests
    jinja2
  ];

  # Tests are disabled due to a circular dependency on Sphinx
  doCheck = false;

  pythonImportsCheck = [ "sphinxcontrib.confluencebuilder" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Confluence builder for sphinx";
    homepage = "https://github.com/sphinx-contrib/confluencebuilder";
    changelog = "https://github.com/sphinx-contrib/confluencebuilder/blob/v${version}/CHANGES.rst";
    license = licenses.bsd1;
    maintainers = with maintainers; [ graysonhead ];
    mainProgram = "sphinx-build-confluence";
  };
}
