
p () {
    cd "/home/roy/Code/$@"

    if [ ! -z $@ ]; then
        tmux rename -t $(tmux display-message -p '#S') $@
    fi
}

pt () {
    if [ -z $@ ]; then;
        return
    fi
    
    tmux has-session -t $@
    if [ $? -eq 0 ]; then
        tmux switch-client -t $@
    else
        tmux new -d -s $@ -c "/home/roy/Code/$@"
    fi
}
