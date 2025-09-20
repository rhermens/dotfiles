sudo pacman -S --needed neovim drawio-desktop

yay -S --noconfirm --needed asdf-vm mongodb-compass-bin postman-bin

asdf plugin add nodejs
asdf plugin add pnpm
asdf plugin add uv
asdf plugin add golang
asdf plugin add rust

asdf install golang latest
asdf install rust latest
asdf install nodejs latest

asdf set golang latest
asdf set rust latest
asdf set nodejs latest

stow nvim
stow dev
