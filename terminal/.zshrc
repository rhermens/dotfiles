source '/usr/share/zsh-antidote/antidote.zsh'

antidote load

path+="/home/roy/.zsh/plugins"
fpath+="/home/roy/.zsh/plugins"

autoload -U compinit && compinit
if [[ -f "/home/roy/.zsh/plugins/p10k.zsh" ]]; then
  source "/home/roy/.zsh/plugins/p10k.zsh"
fi

# History options should be set in .zshrc and after oh-my-zsh sourcing.
# See https://github.com/nix-community/home-manager/issues/177.
HISTSIZE="10000"
SAVEHIST="10000"

HISTFILE="/home/roy/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"

setopt HIST_FCNTL_LOCK
unsetopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
unsetopt HIST_IGNORE_ALL_DUPS
unsetopt HIST_SAVE_NO_DUPS
unsetopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
unsetopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY
unsetopt EXTENDED_HISTORY


source <(fzf --zsh)
eval "$(direnv hook zsh)"

alias -- ll='ls --color=auto -alF'
alias -- vim=nvim

export EDITOR="nvim"
export FZF_ALT_C_COMMAND="fd --type d --hidden --no-ignore --follow --exclude node_modules --exclude vendor --exclude .git"
export PNPM_HOME="/home/roy/.local/share/pnpm"
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:/home/roy/.dotnet/tools:$PNPM_HOME${PATH:+:}$PATH"
