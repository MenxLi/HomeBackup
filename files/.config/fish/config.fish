#
#https://gitlab.com/dwt1/dotfiles/-/blob/master/.config/fish/config.fish
#
### ADDING TO THE PATH
# First line removes the path; second line sets it.  Without the first line,
# your path gets massive and fish becomes very slow.
set -e fish_user_paths
set -U fish_user_paths $HOME/.local/bin $HOME/Applications $fish_user_paths
fish_add_path -m $HOME/bin

### EXPORT ###
set fish_greeting                                 # Supresses fish's intro message
set TERM "xterm-256color"                         # Sets the terminal type
set EDITOR "nvim"                 # $EDITOR use Emacs in terminal


### "nvim" as manpager
# set -x MANPAGER "nvim -c 'set ft=man' -"

### AUTOCOMPLETE AND HIGHLIGHT COLORS ###
set fish_color_normal brcyan
set fish_color_autosuggestion '#7d7d7d'
set fish_color_command brcyan
set fish_color_error '#ff6c6b'
set fish_color_param brcyan

# git
alias gaa='git add .'
alias gclone='git clone'
alias gcmsg='git commit -m'
alias gpull='git pull origin'
alias gp='git push origin'


if status is-interactive
    # Commands to run in interactive sessions can go here
end
