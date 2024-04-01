# Check if TMUX is not set, then start TMUX
if [[ -z $TMUX ]]; then
    tmux new-session -d -s default
    eval "$TMUX"
    tmux attach-session -d -t default
fi

# Load Starship prompt
eval "$(starship init zsh)"

# Remove Zsh greeting
unsetopt PROMPT_SP

# Command history options
export HISTFILESIZE=10000
export HISTSIZE=10000
setopt HIST_IGNORE_ALL_DUPS
setopt INC_APPEND_HISTORY

# Aliases
alias h="sudo systemctl hibernate"
alias shutdown="sudo shutdown -h now"
alias copy="xclip -selection clipboard"
alias x=exit
alias vim="nvim"
alias v="nvim"
alias vw="nvim -u $HOME/.config/vscode_nvim/init.vim -c VimwikiIndex"
alias untar="tar -xvzf"
alias adb="$HOME/Android/Sdk/platform-tools/adb"
alias sp="speedtest-cli --no-upload"
alias go="/usr/local/go/bin/go"
alias docker="sudo docker"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME'
alias ll='ls -lah'
alias history='history -rn 0 | less'
alias gdu='gdu-go --si'
alias c="caffeinate -d"

# "r" alias for "ranger"
# - Copied this function from here: https://github.com/ranger/ranger/issues/1554
# Changed keybinding from Q to S
function r {
    local IFS=$'\t\n'
    local tempfile="$(mktemp -t tmp.XXXXXX)"
    local ranger_cmd=(
        command
        ranger
        --cmd="map S chain shell echo %d > "$tempfile"; quitall"
    )
    
    ${ranger_cmd[@]} "$@"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
        cd -- "$(cat "$tempfile")" || return
    fi
    command rm -f -- "$tempfile" 2>/dev/null
}

# Git Aliases
alias gs="git status"
alias ga="git add"
alias gcm="git commit"
alias gco="git checkout"
alias gb="git branch --sort=-committerdate --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:cyan)%(authorname)%(color:reset) %(color:dim white)(%(committerdate:relative))%(color:reset)'"
alias gacm="git add .;git commit"
alias gl="git log"
alias gll='git log --pretty="%C(auto)%h %C(auto)%d%Creset%n    %C(cyan)%an %C(dim white)%ad%n    %s%Creset%n" --date=format:"%a %Y-%m-%d %H:%M"  --graph'
alias glla='git log --full-history --pretty="%C(auto)%h %C(auto)%d%Creset%n    %C(cyan)%an %C(dim white)%ad%n    %s%Creset%n" --date=format:"%a %Y-%m-%d %H:%M"  --date-order --skip=0 --branches --tags --remotes --graph'
alias gpul="git pull"
alias gpsh="git push"
alias gsh="git stash"
alias gshp="git stash pop"

# Defaults
export EDITOR=nvim

# Use vim keybindings for zsh
bindkey -v
bindkey -M viins 'kj' vi-cmd-mode
bindkey -v '^?' backward-delete-char

# ============== My tools/programs ================
# paths
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export ANDROID_SDK_ROOT="$HOME/Library/Android/sdk/"
export FLUTTER_ROOT="$HOME/Tools/flutter"

# flutter
export PATH="$PATH:$HOME/Tools/flutter/bin"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# java
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"

# nnn
n () {
    # Block nesting of nnn in subshells
    [ "${NNNLVL:-0}" -eq 0 ] || {
        echo "nnn is already running"
        return
    }

    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    command nnn "$@"

    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    }
}

# Load Angular CLI autocompletion.
# source <(ng completion script)

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

# ZSH Autocomplete related
bindkey -M menuselect '\r' .accept-line
