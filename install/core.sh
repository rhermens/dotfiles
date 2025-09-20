sudo pacman -S --needed --noconfirm git zsh base-devel wget curl stow

mkdir -p "$HOME/.pkg"

if ! [ -d ~/.pkg/yay ]; then
    git clone https://aur.archlinux.org/yay.git "$HOME/.pkg/yay"
    makepkg -si -D "$HOME/.pkg/yay"
fi

stow core
