{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    hunspell
    hunspellDicts.nl_nl
    hunspellDicts.en-us
  ];
}
