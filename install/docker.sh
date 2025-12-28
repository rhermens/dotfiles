sudo groupadd docker
sudo usermod -aG docker $USER

if [ -z "${WSL_DISTRO_NAME}" ]; then
    sudo pacman -S --needed --noconfirm docker docker-compose

    sudo systemctl enable docker
    sudo systemctl start docker
fi
