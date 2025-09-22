sudo pacman -S --needed --noconfirm neovim drawio-desktop

yay -S --noconfirm --needed asdf-vm mongodb-compass-bin postman-bin

asdf plugin add nodejs
asdf plugin add pnpm
asdf plugin add uv
asdf plugin add golang
asdf plugin add rust

asdf install golang latest
asdf install rust latest
asdf install nodejs latest

asdf set --home golang latest
asdf set --home rust latest
asdf set --home nodejs latest
asdf set --home pnpm latest

stow nvim
stow dev
