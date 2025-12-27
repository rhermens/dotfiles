if [ -z "${WSL_DISTRO_NAME}" ]; then
    sudo pacman -S --needed --noconfirm obsidian libreoffice-fresh gedit transmission-gtk \
        discord \
        vlc vlc-plugin-ffmpeg libmicrodns protobuf vlc-plugin-avahi vlc-plugin-chromecast

    yay -S --noconfirm --needed google-chrome slack-desktop
else
    winget install Google.Chrome SlackTechnologies.Slack Discord.Discord VideoLAN.VLC Obsidian.Obsidian
fi
