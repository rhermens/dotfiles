export EDITOR=nvim

# Use powerline
USE_POWERLINE="true"
bindkey -v

# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
    source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
    source /usr/share/zsh/manjaro-zsh-prompt
fi

if [[ -e ~/.p10k.zsh ]]; then
    source ~/.p10k.zsh
fi

if [[ -e /usr/share/fzf/key-bindings.zsh ]]; then
    if [[ -e /usr/bin/rg ]]; then
        export FZF_DEFAULT_COMMAND="rg --files --no-ignore-vcs --hidden -g !node_modules -g !vendor -g !.git"
    fi
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
fi

if [[ -e /usr/share/nvm/init-nvm.sh ]]; then
    source /usr/share/nvm/init-nvm.sh
fi

if [[ -e ~/.dotnet/dotnet ]]; then
    export DOTNET_ROOT=$HOME/.dotnet
    export PATH=$PATH:$DOTNET_ROOT/tools
    export PATH=$PATH:$DOTNET_ROOT
fi

p () {
    cd "/home/roy/Code/$@"
}

alias ll="ls --color=auto -alF"
alias vim="nvim"
alias step="step-cli"

export GOPATH=$HOME/Code/go
export PATH=$PATH:$GOPATH/bin

# The next line updates PATH for the Google Cloud SDK.
if [ -f '~/gcloud/google-cloud-sdk/path.zsh.inc' ]; then . '~/gcloud/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '~/gcloud/google-cloud-sdk/completion.zsh.inc' ]; then . '~/gcloud/google-cloud-sdk/completion.zsh.inc'; fi
