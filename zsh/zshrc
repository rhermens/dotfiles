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

export PATH="/home/roy/.local/bin:$PATH"
export EDITOR=nvim
alias ll="ls --color=auto -alF"
alias vim="nvim"

source ~/.zsh/settings.zsh
source ~/.zsh/dev.zsh
source ~/.zsh/fzf.zsh
source ~/.zsh/fn.zsh

if [[ -f /opt/homebrew/bin/brew ]]; then
    export PATH=/opt/homebrew/bin:$PATH
fi

if [[ -f ~/antigen/antigen.zsh ]] && [[ ! -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
    source ~/antigen/antigen.zsh

    antigen bundle zsh-users/zsh-syntax-highlighting
    antigen bundle zsh-users/zsh-autosuggestions
    antigen bundle jeffreytse/zsh-vi-mode

    antigen apply
fi
