sudo pacman -S --needed --noconfirm docker docker-compose

sudo groupadd docker
sudo usermod -aG docker $USER

sudo systemctl enable docker
sudo systemctl start docker
