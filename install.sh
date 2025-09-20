## Init
mkdir -p "$HOME/.pkg"

source ./install/core.sh

git remote set-url origin "git@github.com:rhermens/dotfiles.git"

git clone "git@github.com:rhermens/notes.git" "$HOME/notes"

git clone https://aur.archlinux.org/yay.git "$HOME/.pkg/yay"
makepkg -si -D "$HOME/.pkg/yay"

source ./install/docker.sh
source ./install/security.sh
source ./install/dev.sh
source ./install/docker.sh
source ./install/file-management.sh
