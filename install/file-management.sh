if [ -z "${WSL_DISTRO_NAME}" ]; then
    sudo pacman -S --needed --noconfirm \
        thunar thunar-archive-plugin thunar-volman \
        gvfs samba gvfs-smb \
        tumbler ffmpegthumbnailer \
        unzip
fi
