{ pkgs, ... }:
let
  wine-x11 = pkgs.symlinkJoin {
    name = "wine-x11";
    paths = [ pkgs.wineWow64Packages.staging ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      for executable in "$out"/bin/*; do
        wrapProgram "$executable" --set WAYLAND_DISPLAY ""
      done
    '';
  };
in
{
  environment.systemPackages = [ wine-x11 ];
}
