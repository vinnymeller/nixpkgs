{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  git,
  nix-update-script,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "git-spice";
  version = "0.24.2";

  src = fetchFromGitHub {
    owner = "abhinav";
    repo = "git-spice";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zt4PG3pWJ0h22fBJnsIVqcSk2BwwuOHdmSOrAMENN70=";
  };

  vendorHash = "sha256-tlAex6SFTprJtpMexMjAUNanamqraHYJuwtABx52rWQ=";

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ git ];

  buildInputs = [ git ];

  ldflags = [
    "-s"
    "-w"
    "-X=main._version=${finalAttrs.version}"
  ];

  __darwinAllowLocalNetworking = true;

  preCheck = lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
    # timeout
    rm testdata/script/branch_submit_remote_prompt.txt
    rm testdata/script/branch_submit_multiple_pr_templates.txt
  '';

  postBuild = ''
    mv $GOPATH/bin/gs $GOPATH/bin/git-spice
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd git-spice \
      --bash <($out/bin/git-spice shell completion bash) \
      --zsh <($out/bin/git-spice shell completion zsh) \
      --fish <($out/bin/git-spice shell completion fish)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Manage stacked Git branches";
    homepage = "https://abhinav.github.io/git-spice/";
    changelog = "https://github.com/abhinav/git-spice/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.vinnymeller ];
    mainProgram = "git-spice";
  };
})
