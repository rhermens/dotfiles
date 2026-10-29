{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    slack
    acli
    inputs.jira-stream.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
