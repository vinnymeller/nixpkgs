{
  lib,
  fetchPypi,
  buildPythonApplication,
}:

buildPythonApplication rec {
  pname = "fortran-language-server";
  version = "1.12.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7Dkh7yPX4rULkzfJFxg47YxrCaxuHk+k3TOINHS9T5A=";
  };

  checkPhase = "$out/bin/fortls --help 1>/dev/null";
  pythonImportsCheck = [ "fortls" ];

  meta = with lib; {
    description = "FORTRAN Language Server for the Language Server Protocol";
    mainProgram = "fortls";
    homepage = "https://pypi.org/project/fortran-language-server/";
    license = [ licenses.mit ];
    maintainers = [ maintainers.sheepforce ];
  };
}
