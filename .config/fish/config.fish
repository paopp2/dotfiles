if not set -q TMUX
    set -g TMUX "tmux new-session -d -s default"
    eval $TMUX
    tmux attach-session -d -t default
end
# THEME PURE #
#set fish_function_path /home/paolopepito/.config/fish/functions/theme-pure/functions/ $fish_function_path
#source /home/paolopepito/.config/fish/functions/theme-pure/conf.d/pure.fish

#starship fish theme config
starship init fish | source

#vim mode
fish_vi_key_bindings
set fish_key_bindings fish_user_key_bindings

# Remove fish greeting
set -g fish_greeting

# Bind p to system paste
bind p fish_clipboard_paste

#ALIASES
alias h="sudo systemctl hibernate"
alias shutdown="sudo shutdown -h now"
alias open="xdg-open"
alias copy="xclip -sel clip"
alias x=exit
alias vim="nvim"
alias vw="vim -u $HOME/.config/vscode_nvim/init.vim -c VimwikiIndex"
# alias vw="nvim.exe -c VimwikiIndex"
alias untar="tar -xvzf"
alias r="ranger"
alias adb="~/Android/Sdk/platform-tools/adb"
alias sp="speedtest-cli --no-upload"
alias go="/usr/local/go/bin/go"
alias docker="sudo docker"
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# GIT ALIASES
#alias git="git.exe"
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
set -gx EDITOR nvim

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH
set --export ANDROID_SDK_ROOT "$HOME/Android/Sdk/"
