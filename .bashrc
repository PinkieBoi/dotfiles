#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR=nvim
export VISUAL=nvim
export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"   # Bat as manpager
export MANROFFOPT="-c"

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.bin" ]; then
    PATH="$HOME/.bin:$PATH"
fi

# Shell integrations
eval "$(fzf --bash)"
source <(op completion bash)

# Load Aliases
[[ -f ~/.config/aliasrc ]] && . ~/.config/aliasrc

# Run program on startup
neofetch | lolcat

