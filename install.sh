## Init
source ./install/core.sh

git remote set-url origin "git@github.com:rhermens/dotfiles.git"

if ! [ -d ~/notes ]; then
    git clone "git@github.com:rhermens/notes.git" "$HOME/notes"
fi

source ./install/security.sh
source ./install/dev.sh
source ./install/docker.sh
source ./install/file-management.sh
source ./install/gaming.sh
source ./install/programs.sh
source ./install/terminal.sh
source ./install/xd.sh
source ./install/wm/hyprland.sh
