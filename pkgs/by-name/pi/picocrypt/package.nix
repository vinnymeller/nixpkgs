{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  copyDesktopItems,
  makeDesktopItem,

  xorg,
  glfw,
  gtk3,
  pkg-config,
  wrapGAppsHook3,
}:

buildGoModule (finalAttrs: {
  pname = "picocrypt";
  version = "1.48";

  src = fetchFromGitHub {
    owner = "Picocrypt";
    repo = "Picocrypt";
    tag = finalAttrs.version;
    hash = "sha256-Gvh6t/jFRBCX+I9CYkXV265PiRSSvH6qAgkU0fA/v4A=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  vendorHash = "sha256-HvtQFoAK4+DX2Mwzf5f39tTnxJcH7Dox/otlvPVczeA=";

  ldflags = [
    "-s"
    "-w"
  ];

  buildInputs =
    # Depends on a vendored, patched GLFW.
    glfw.buildInputs or [ ]
    ++ glfw.propagatedBuildInputs or [ ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      gtk3
      xorg.libXxf86vm
    ];

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    wrapGAppsHook3
  ];

  env.CGO_ENABLED = 1;

  postInstall = ''
    mv $out/bin/Picocrypt $out/bin/picocrypt-gui
    install -Dm644 $src/images/key.svg $out/share/icons/hicolor/scalable/apps/picocrypt.svg
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Picocrypt";
      exec = "picocrypt-gui";
      icon = "picocrypt";
      comment = finalAttrs.meta.description;
      desktopName = "Picocrypt";
      categories = [ "Utility" ];
    })
  ];

  meta = {
    description = "Very small, very simple, yet very secure encryption tool, written in Go";
    homepage = "https://github.com/Picocrypt/Picocrypt";
    changelog = "https://github.com/Picocrypt/Picocrypt/blob/${finalAttrs.version}/Changelog.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ryand56 ];
    mainProgram = "picocrypt-gui";
  };
})
