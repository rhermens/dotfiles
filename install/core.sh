sudo pacman -S --needed --noconfirm git zsh base-devel wget curl stow sudo openssh less

if [ -n "${WSL_DISTRO_NAME}" ]; then
    winget.exe Git.Git Microsoft.OpenSSH.Preview
fi

mkdir -p "$HOME/.pkg"

if ! [ -d ~/.pkg/yay ]; then
    git clone https://aur.archlinux.org/yay.git "$HOME/.pkg/yay"
    makepkg -si -D "$HOME/.pkg/yay"
fi

stow core
