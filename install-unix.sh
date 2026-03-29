
## Init
source ./install/core.sh

if ! [ -e ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -C royhermens@hotmail.com
    echo "SSH Key created, add it to github.."
    exit 0
fi

if ! [ -d ~/dotfiles ]; then
    git clone "git@github.com:rhermens/dotfiles.git" ~/dotfiles
else
    git remote set-url origin "git@github.com:rhermens/dotfiles.git"
fi

if ! [ -d ~/notes ]; then
    git clone "git@github.com:rhermens/notes.git" "$HOME/notes"
fi

if [ -z "$WSL_DISTRO_NAME" ]; then
    source ./install/security.sh
    source ./install/xd.sh
    source ./install/wm/hyprland.sh
    source ./install/file-management.sh
fi

source ./install/security.sh
source ./install/dev.sh
source ./install/docker.sh
source ./install/gaming.sh
source ./install/programs.sh
source ./install/terminal.sh
