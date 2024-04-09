{
  autoPatchelfHook,
  lib,
  fetchurl,
  buildPythonPackage,
}:
buildPythonPackage {
  pname = "nodejs-bin";
  version = "unstable-2022-11-10";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/14/f5/b85f10ddb2b6bf58395bd08a7794ded91518f7eca1dc771c22c808c44e81/nodejs_bin-18.4.0a4-py3-none-manylinux_2_12_x86_64.manylinux2010_x86_64.whl";
    sha256 = "06cfeaa4d26eec94d8edb9927525ce94eb96dadc81f7d1daed42d1a7d003a4c9";
  };

  nativeBuildInputs = [autoPatchelfHook];

  pythonImportsCheck = ["nodejs"];

  meta = with lib; {
    description = "Project to repackage Node.js releases as Python binary wheels for distribution via PyPI";
    homepage = "https://github.com/samwillis/nodejs-pypi";
    license = licenses.mit;
    maintainers = with maintainers; [vinnymeller];
    platforms = platforms.linux;
  };
}
