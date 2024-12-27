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
# alias h="sudo systemctl hibernate"
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
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias ll='ls -lah'
alias h='print -zr -- $(history -rn 0 | fzf --reverse --info=inline)'
alias gdu='gdu-go --si'
alias c="caffeinate -d"
alias f="fzf"
alias d="docker"
alias dc="docker-compose"
alias awslocal="aws --endpoint-url=http://localhost:4566"
alias code="cursor" # Remove this should you ever return to VSCode from Cursor

# "r" = yazi; cd on exit
function r {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# "r" alias for "ranger"
# - Copied this function from here: https://github.com/ranger/ranger/issues/1554
# Changed keybinding from Q to S
# function r {
#     local IFS=$'\t\n'
#     local tempfile="$(mktemp -t tmp.XXXXXX)"
#     local ranger_cmd=(
#         command
#         ranger
#         --cmd="map S chain shell echo %d > "$tempfile"; quitall"
#     )
#     
#     ${ranger_cmd[@]} "$@"
#     if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
#         cd -- "$(cat "$tempfile")" || return
#     fi
#     command rm -f -- "$tempfile" 2>/dev/null
# }

# Git Aliases
alias gs="git status"
alias ga="git add"
alias gcm="git commit"
alias gb="git branch --sort=-committerdate --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:cyan)%(authorname)%(color:reset) %(color:dim white)(%(committerdate:relative))%(color:reset)'"
alias gacm="git add .;git commit"
alias gl="git log"
alias gll='git log --pretty="%C(auto)%h %C(auto)%d%Creset%n    %C(cyan)%an %C(dim white)%ad%n    %s%Creset%n" --date=format:"%a %Y-%m-%d %H:%M"  --graph'
alias glla='git log --full-history --pretty="%C(auto)%h %C(auto)%d%Creset%n    %C(cyan)%an %C(dim white)%ad%n    %s%Creset%n" --date=format:"%a %Y-%m-%d %H:%M"  --date-order --skip=0 --branches --tags --remotes --graph'
alias gpul="git pull"
alias gpsh="git push"
alias gsh="git stash"
alias gshp="git stash pop"
alias gfa="git fetch --all"

# cd -> zoxide
export _ZO_RESOLVE_SYMLINKS=1
eval "$(zoxide init zsh --cmd cd)"

function gco () {
    if [[ $# -eq 0 ]]; then
        gb | fzf --reverse | xargs | cut -d ' ' -f 1 | xargs git checkout
    else
        git checkout "$@"
    fi
}

function gcoa {
    gb --all | fzf --reverse | xargs | cut -d ' ' -f 1 | sed 's/^origin\///' | xargs git checkout
}

# Use vim keybindings for zsh
bindkey -v
bindkey -M viins 'kj' vi-cmd-mode
bindkey -v '^?' backward-delete-char

# fzf keybindings
eval "$(fzf --zsh)"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

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

# asdf setup
. /opt/homebrew/opt/asdf/libexec/asdf.sh

# === HapInS JIRA link scripts: ===
jrl() {
    echo -n "[AOIKE-$1](https://hapins.atlassian.net/browse/AOIKE-$1)" | pbcopy
}

jro() {
    open "https://hapins.atlassian.net/browse/AOIKE-$1"
}
# =================================

# Rust related
. "$HOME/.cargo/env"
