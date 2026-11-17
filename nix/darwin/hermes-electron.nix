# Electron renamed to Hermes.app, for Hermes Desktop on macOS.
#
# Upstream runs Hermes on nixpkgs' generic Electron.app, so the Dock shows
# "Electron" and a pinned icon opens plain Electron. This bundle carries the
# Hermes name and icon. Its launcher runs the Home Manager hermes-desktop
# wrapper, which execs the Electron binary inside this same bundle.
{ inputs, pkgs, username }:
let
  # Hermes's own nixpkgs, so version and headers match its native modules.
  hermesPkgs = inputs.hermes-agent.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
hermesPkgs.electron.overrideAttrs (old: {
  pname = "hermes-electron";
  nativeBuildInputs = old.nativeBuildInputs ++ [ hermesPkgs.python3Minimal ];
  buildCommand = ''
    mkdir -p $out/Applications
    unzip $src
    mv Electron.app $out/Applications/Hermes.app
    app=$out/Applications/Hermes.app/Contents

    cp ${inputs.hermes-agent}/apps/desktop/assets/icon.icns $app/Resources/hermes.icns

    python3 - $app/Info.plist <<'EOF'
    import plistlib, sys
    path = sys.argv[1]
    with open(path, "rb") as f:
        info = plistlib.load(f)
    info.update(
        CFBundleName="Hermes",
        CFBundleDisplayName="Hermes",
        CFBundleIdentifier="com.nousresearch.hermes",
        CFBundleIconFile="hermes.icns",
        CFBundleExecutable="Hermes",
    )
    with open(path, "wb") as f:
        plistlib.dump(info, f)
    EOF

    cat > $app/MacOS/Hermes <<'EOF'
    #!/bin/sh
    exec /etc/profiles/per-user/${username}/bin/hermes-desktop "$@"
    EOF
    chmod +x $app/MacOS/Hermes

    mkdir -p $out/bin
    makeWrapper $app/MacOS/Electron $out/bin/electron
  '';
})
