{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = (if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty);
    enableZshIntegration = true;
    settings = {
      font-family = "Lilex Nerd Font Mono";
      adjust-cell-height = (if pkgs.stdenv.isDarwin then 4 else 2);
      theme = "TokyoNight Night";
      alpha-blending = "linear-corrected";
      maximize = true;

      background-image = "~/dotfiles/img/bg.jpg";
      background-image-opacity = 0.0005;
      background-image-fit = "cover";

      window-show-tab-bar = "never";
      window-theme = "ghostty";
      window-decoration = "none";

      app-notifications = "no-clipboard-copy";

      gtk-titlebar = true;
      gtk-toolbar-style = "flat";

      clipboard-read = "allow";
      clipboard-write = "allow";

      # Send Alt sequences from left Option while preserving special characters
      # on right Option.
      macos-option-as-alt = "left";

      # Keep Linux-style clipboard shortcuts available on macOS.
      keybind = [
        "ctrl+shift+c=copy_to_clipboard:mixed"
        "ctrl+shift+v=paste_from_clipboard"
      ];
    };
  };
}
