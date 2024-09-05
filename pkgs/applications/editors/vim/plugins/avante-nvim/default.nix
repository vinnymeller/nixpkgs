{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  vimUtils,
}:

let
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "yetone";
    repo = "avante.nvim";
    rev = "refs/tags/v${version}";
    hash = "sha256-p0ILVK1nADMFQ2FCVgWKouoEr+Fenf62p+RMgeRCx7E=";
  };

  meta = with lib; {
    description = "Neovim plugin designed to emulate the behaviour of the Cursor AI IDE";
    homepage = "https://github.com/yetone/avante.nvim";
    license = licenses.asl20;
    maintainers = [ ];
  };

  avante-lib = rustPlatform.buildRustPackage {
    pname = "avante-lib";
    inherit version src meta;
    cargoLock = {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "mlua-0.10.0-beta.1" = "sha256-ZEZFATVldwj0pmlmi0s5VT0eABA15qKhgjmganrhGBY=";
      };
    };

    nativeBuildInputs = [
      pkg-config
      openssl
    ];

    buildPhase = ''
      export PKG_CONFIG_PATH=${openssl.dev}/lib/pkgconfig:$PKG_CONFIG_PATH
      make BUILD_FROM_SOURCE=true
    '';

    installPhase = ''
      mkdir -p $out
      cp ./build/*.so $out/
    '';

    doCheck = false;
  };
in

vimUtils.buildVimPlugin {
  pname = "avante.nvim";
  inherit version src meta;

  # The plugin expects the dynamic libraries to be under build/
  postInstall = ''
    mkdir -p $out/build
    ln -s ${avante-lib}/*.so $out/build
  '';
}
