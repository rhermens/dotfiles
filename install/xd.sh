sudo pacman -S --needed --noconfirm playerctl \
    ttf-iosevka-nerd

yay -S --noconfirm --needed xcursor-openzone

mkdir -p ~/.pkg
if ! [ -d ~/.pkg/Tokyonight-GTK-Theme ]; then
    git clone git@github.com:Fausto-Korpsvart/Tokyonight-GTK-Theme.git ~/.pkg/Tokyonight-GTK-Theme
fi

/bin/env sh -c "~/.pkg/Tokyonight-GTK-Theme/themes/install.sh --tweaks storm"
stow xd

