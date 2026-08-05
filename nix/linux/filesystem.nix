{ pkgs }:
{
  environment.systemPackages = with pkgs; [
    ffmpegthumbnailer
    gvfs
    samba
    ntfs3g
  ];
}
