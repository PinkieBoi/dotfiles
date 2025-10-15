#                   __
#                  /\ \
#     ____     ____\ \ \___   _ __   ___
#    /\_ ,`\  /',__\\ \  _ `\/\`'__\/'___\
#  __\/_/  /_/\__, `\\ \ \ \ \ \ \//\ \__/
# /\_\ /\____\/\____/ \ \_\ \_\ \_\\ \____\
# \/_/ \/____/\/___/   \/_/\/_/\/_/ \/____/
#
#
# Set the directory to store zinit & plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
# Download Zinit if not found
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

export EDITOR=nvim
export VISUAL=nvim
export MANPAGER="sh -c 'col -bx | bat -l man -p'"   # Bat as manpager
export MANROFFOPT="-c"
export SSH_AUTH_SOCK=$HOME/.bitwarden-ssh-agent.sock

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.bin" ]; then
    PATH="$HOME/.bin:$PATH"
fi

# Enable catppuccin syntax highlighting
source ~/.config/zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh

# Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::thefuck
zinit snippet OMZP::archlinux
zinit snippet OMZP::command-not-found

# Load Completions
autoload -U compinit && compinit
zinit cdreplay -q

bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTFILE=~/.config/zsh/zsh_history
HISTDUP=erase

# Zsh Options
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt extendedglob
setopt nocaseglob
setopt rcexpandparam
setopt numericglobsort
setopt autocd

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
eval "$(oh-my-posh init zsh --config ~/.config/OhMyPosh/catppuccin_mocha.omp.json)"

# Load Aliases
[[ -f ~/.config/aliasrc ]] && . ~/.config/aliasrc

# Run program on startup
# colorscript random

