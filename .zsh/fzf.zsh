if [[ -e /usr/share/fzf/key-bindings.zsh ]]; then
    if [[ -e /usr/bin/fd ]]; then
        export FZF_ALT_C_COMMAND="fd --type d --hidden --no-ignore --follow --exclude node_modules --exclude vendor --exclude .git"
    fi
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
fi
