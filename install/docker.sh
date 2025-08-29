sudo pacman -S docker docker-compose

sudo groupadd docker
sudo usermod -aG docker $USER

sudo pacman -S docker
sudo systemctl enable docker
sudo systemctl start docker
