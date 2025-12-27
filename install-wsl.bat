wsl --install archlinux --name archlinux
wsl --set-default archlinux

REM wsl -u root -- useradd -m roy
REM wsl -u root -- passwd roy
REM wsl -u root -- groupadd sudo
REM wsl -u root -- usermod -aG sudo roy

wsl -u roy --cd %cd% -- "./install.sh"
