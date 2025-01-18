

if [[ -e /usr/share/nvm/init-nvm.sh ]]; then
    source /usr/share/nvm/init-nvm.sh
fi

if [[ -e ~/chrome-shell/shell/keybindings.zsh ]]; then
    source ~/chrome-shell/shell/keybindings.zsh
fi

if [[ -e /opt/asdf-vm/asdf.sh ]]; then
    source /opt/asdf-vm/asdf.sh
fi

if [[ -e "$HOME/.nvm/nvm.sh" ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

if [[ -e /usr/bin/pyenv ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH=$PYENV_ROOT/bin:$PATH
    eval "$(pyenv init -)"
fi

# pnpm
export PNPM_HOME="/home/roy/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

if [[ -e ~/.dotnet/dotnet ]]; then
    export DOTNET_WATCH_SUPPRESS_EMOJIS=1
    export ASPNETCORE_ENVIRONMENT=Development
    export DOTNET_ROOT=$HOME/.dotnet
    export PATH=$PATH:$DOTNET_ROOT/tools
    export PATH=$PATH:$DOTNET_ROOT
fi
if [[ -e ~/netcoredbg/netcoredbg ]]; then
    export PATH=$PATH:$HOME/netcoredbg
fi

if [[ -e ~/.cargo/env ]]; then
    . "$HOME/.cargo/env"
    export PATH=/home/roy/.cargo/bin:$PATH
fi

export PATH=/home/roy/.local/share/coursier/bin:$PATH

export PATH="$HOME/.cabal/bin:$HOME/.ghcup/bin:$PATH"
[ -f "/home/roy/.ghcup/env" ] && source "/home/roy/.ghcup/env" # ghcup-env

alias step="step-cli"

export GOPATH=$HOME/Code/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin

# The next line updates PATH for the Google Cloud SDK.
if [ -f '~/gcloud/google-cloud-sdk/path.zsh.inc' ]; then . '~/gcloud/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '~/gcloud/google-cloud-sdk/completion.zsh.inc' ]; then . '~/gcloud/google-cloud-sdk/completion.zsh.inc'; fi

# bun completions
[ -s "/home/roy/.bun/_bun" ] && source "/home/roy/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
