{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  services.desktopManager.gnome = {
    enable = true;
  };
  services.displayManager.gdm = {
    enable = true;
  };
}
