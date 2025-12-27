if [ -z "${WSL_DISTRO_NAME}" ]; then
    sudo pacman -S --needed --noconfirm steam
else
    winget.exe install Valve.Steam Blizzard.BattleNet
fi
