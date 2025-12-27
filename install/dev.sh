sudo pacman -S --needed --noconfirm neovim act

yay -S --noconfirm --needed asdf-vm

if [ -z "${WSL_DISTRO_NAME}" ]; then
	yay -S --noconfirm mongodb-compass-bin postman-bin
else
    winget.exe install MongoDB.Compass.Full Postman.Postman
fi

asdf plugin add nodejs
asdf plugin add pnpm
asdf plugin add uv
asdf plugin add golang
asdf plugin add rust

asdf install golang latest
asdf install rust latest
asdf install nodejs latest
asdf install pnpm latest

asdf set --home golang latest
asdf set --home rust latest
asdf set --home nodejs latest
asdf set --home pnpm latest

stow nvim
stow dev
