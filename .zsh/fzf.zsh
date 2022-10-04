if [[ -e /usr/share/fzf/key-bindings.zsh ]]; then
    if [[ -e /usr/bin/rg ]]; then
        export FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden -g !node_modules -g !vendor -g !.git"
    fi
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
fi
