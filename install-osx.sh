
## Init
source ./install/core-osx.sh

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

source ./install/security-osx.sh
source ./install/xd-osx.sh
source ./install/dev-osx.sh
source ./install/docker-osx.sh
source ./install/programs-osx.sh
source ./install/terminal-osx.sh
