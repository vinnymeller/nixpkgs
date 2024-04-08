{
  lib,
  python3,
  fetchFromGitHub,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "basedpyright";
  version = "1.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "detachhead";
    repo = "basedpyright";
    rev = "v${version}";
    hash = "sha256-AHCeYWCL9XgjiMZdqvUFEj/tgL0ags/xAtcOjlJ/304=";
  };

  nativeBuildInputs = [
    python3.pkgs.nodejs-bin
    python3.pkgs.pdm-backend
  ];

  propagatedBuildInputs = with python3.pkgs; [
    nodejs-bin
  ];

  pythonImportsCheck = ["basedpyright"];

  meta = with lib; {
    description = "Pyright fork with various type checking improvements, improved vscode support and pylance features built into the language server";
    homepage = "https://github.com/detachhead/basedpyright";
    license = licenses.mit;
    maintainers = with maintainers; [vinnymeller];
    mainProgram = "basedpyright";
  };
}
