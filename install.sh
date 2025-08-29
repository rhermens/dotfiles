## Init
sudo pacman -S git neovim zsh base-devel unzip

git clone "git@github.com:rhermens/notes.git" "$HOME/notes"
git remote set-url origin "git@github.com:rhermens/dotfiles.git"

## Home Manager
mkdir -p "$HOME/.config/home-manager/"
ln -s "$HOME/dotfiles/flake.nix" "$HOME/.config/home-manager/flake.nix"
ln -s "$HOME/dotfiles/flake.lock" "$HOME/.config/home-manager/flake.lock"

sudo groupadd nix-users
sudo usermod -aG nix-users $USER
su - $USER

sudo pacman -S nix
sudo systemctl enable nix-daemon
sudo systemctl start nix-daemon

home-manager switch

source ./install/docker.sh
