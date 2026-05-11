if [ -z "$WSL_DISTRO_NAME" ]; then
    sudo pacman -S --needed --noconfirm gnome-keyring seahorse
    yay -S --noconfirm --needed 1password
fi
