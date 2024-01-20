source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

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

# Aliases
alias h="sudo systemctl hibernate"
alias shutdown="sudo shutdown -h now"
alias copy="xclip -selection clipboard"
alias x=exit
alias vim="nvim"
alias vw="nvim -u $HOME/.config/vscode_nvim/init.vim -c VimwikiIndex"
alias untar="tar -xvzf"
alias r="ranger"
alias adb="$HOME/Android/Sdk/platform-tools/adb"
alias sp="speedtest-cli --no-upload"
alias go="/usr/local/go/bin/go"
alias docker="sudo docker"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/.git --work-tree=$HOME'
alias ll='ls -lah'

# Git Aliases
alias gs="git status"
alias ga="git add"
alias gcm="git commit"
alias gco="git checkout"
alias gb="git branch"
alias gacm="git add .;git commit"
alias gl="git log"
alias gll="git log --oneline --graph"
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
source <(ng completion script)
