# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -e ~/powerlevel10k/powerlevel10k.zsh-theme ]]; then
    source ~/powerlevel10k/powerlevel10k.zsh-theme
fi

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -e ~/.p10k.zsh ]]; then
    source ~/.p10k.zsh
fi
# End p10k

export EDITOR=nvim

bindkey -v

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

if [[ -e "$HOME/.nvm/nvm.sh" ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
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
export PATH=$PATH:/usr/local/go/bin

# The next line updates PATH for the Google Cloud SDK.
if [ -f '~/gcloud/google-cloud-sdk/path.zsh.inc' ]; then . '~/gcloud/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '~/gcloud/google-cloud-sdk/completion.zsh.inc' ]; then . '~/gcloud/google-cloud-sdk/completion.zsh.inc'; fi

if [ -f '/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh' ]; then
    source '/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh'
fi
