sudo pacman -S --needed --noconfirm \
    fzf fd ripgrep tmux direnv \
    tldr \


if [ -z "${WSL_DISTRO_NAME}" ]; then
    sudo pacman -S --needed --noconfirm kitty
fi

yay -S --needed --noconfirm \
    zsh-antidote

stow terminal
