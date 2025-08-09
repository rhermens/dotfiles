{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ardour
    surge-XT
    x42-avldrums
  ];
}
