#
#   ~/.zshrc
#

# Exports
export EDITOR='nvim'
export VISUAL='kate'
export LANG=en_GB.UTF-8
export PATH="/usr/lib/python3.9/site-packages:$HOME/.emacs.d/bin:$HOME/.local/bin:$HOME/.bin:$HOME/.local/kitty.app/bin:$PATH"
export HISTCONTROL=ignoreboth:erasedups

## Options section
setopt extendedglob
setopt nocaseglob
setopt rcexpandparam
setopt numericglobsort
setopt appendhistory
setopt autocd
setopt GLOB_DOTS

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' rehash true
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

## ZSH History
HISTFILE=~/.config/shell/zsh/zhistory
HISTSIZE=100000
SAVEHIST=100000
HIST_STAMPS="dd/mm/yyyy"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Run program on startup
colorscript random

# Bash Insulter
if [ -f /etc/bash.command-not-found ]; then
    . /etc/bash.command-not-found
fi

### Load dedicated ZSH Alias file
[[ -f ~/.config/shell/aliasrc ]] && . ~/.config/shell/aliasrc

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.config/shell/zsh/p10k.zsh ]] || source ~/.config/shell/zsh/p10k.zsh

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
