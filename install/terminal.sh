sudo pacman -S --needed --noconfirm \
    fzf fd ripgrep tmux direnv \
    tldr \


if [ -z "${WSL_DISTRO_NAME}" ]; then
    sudo pacman -S --needed --noconfirm kitty
else
    winget.exe install BurntSushi.ripgrep.MSVC
fi

yay -S --needed --noconfirm \
    zsh-antidote

stow terminal
