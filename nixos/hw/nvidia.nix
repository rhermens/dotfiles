{ ... }:
{
  nixpkgs.config.cudaSupport = true;

  hardware.nvidia = {
    open = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
