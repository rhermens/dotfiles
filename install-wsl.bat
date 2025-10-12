wsl --install archlinux --name archlinux
wsl --set-default archlinux

wsl -u root -- useradd -m roy
wsl -u root -- passwd roy
wsl -u root -- groupadd sudo
wsl -u root -- usermod -aG sudo roy

wsl -u roy --cd %cd% -- "./install.sh"
