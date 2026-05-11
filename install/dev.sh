sudo pacman -S --needed --noconfirm neovim act mise tree-sitter-cli

if [ -z "${WSL_DISTRO_NAME}" ]; then
	yay -S --noconfirm mongodb-compass-bin postman-bin
fi

mise install

stow nvim
