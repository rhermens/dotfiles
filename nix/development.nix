{ config, pkgs, lib, ... }:
let
  miseVersion = "2026.6.14";
  misePlatforms = {
    x86_64-linux = {
      asset = "linux-x64-musl";
      hash = "sha256-fRKWy/aQDvdyvYfDmfUvxqiHWbi9oeeLSQiBrumHJBc=";
    };
    aarch64-linux = {
      asset = "linux-arm64-musl";
      hash = "sha256-xhp/J37eATU+ZwwfccbhrX/Vsp7vweM5QPnNiOa8cSc=";
    };
    aarch64-darwin = {
      asset = "macos-arm64";
      hash = "sha256-aQSNq7Kz81ZvkIGxOAKcaMCq50JVplevrVOmt7WnwpA=";
    };
    x86_64-darwin = {
      asset = "macos-x64";
      hash = "sha256-ql4UMR9W8Pqn/EM1zGyv+bvawL4b7vIF9S/32Qnp9pA=";
    };
  };
  misePlatform = misePlatforms.${pkgs.stdenv.hostPlatform.system}
    or (throw "Unsupported mise-bin platform: ${pkgs.stdenv.hostPlatform.system}");
  miseBin = pkgs.stdenvNoCC.mkDerivation {
    pname = "mise-bin";
    version = miseVersion;
    src = pkgs.fetchzip {
      url = "https://github.com/jdx/mise/releases/download/v${miseVersion}/mise-v${miseVersion}-${misePlatform.asset}.tar.gz";
      hash = misePlatform.hash;
    };
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -R . $out/
      chmod +x $out/bin/mise
      runHook postInstall
    '';
    meta.mainProgram = "mise";
  };
in
{
  home.packages = [
    pkgs.gcc
    pkgs.gnumake
    pkgs.cmake
    pkgs.rustup
    pkgs.go
    pkgs.python3
    pkgs.nodejs
    pkgs.bun

    pkgs.typescript-language-server
    pkgs.python314Packages.pylatexenc

    pkgs.delta
  ];

  home.file = {
    ".config/git".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/core/.config/git";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim/.config/nvim";
    ".config/doom".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/emacs/.config/doom";
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/terminal/.config/tmux";
    ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/terminal/.config/ghostty";
    ".config/wt".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dev/.config/wt";
    ".tool-versions".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/dev/.tool-versions";
  };

  programs.mise = {
    enable = true;
    package = miseBin;
    enableZshIntegration = true;
  };
}
