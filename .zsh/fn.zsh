
p () {
    cd "/home/roy/Code/$@"
    tmux rename -t $(tmux display-message -p '#S') $@
}

pt () {
    tmux has-session -t $@
    if [ $? -eq 0 ]; then
        tmux switch-client -t $@
    else
        tmux new -d -s $@ -c "/home/roy/Code/$@"
    fi
}
