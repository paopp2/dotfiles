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

source ~/.zsh_aliases

# cd -> zoxide
if [ -z "$DISABLE_ZOXIDE" ]; then
    export _ZO_RESOLVE_SYMLINKS=1
    eval "$(zoxide init zsh --cmd cd)"
fi

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

# alias claude="/Users/nicolaspaolopepito/.claude/local/claude"
