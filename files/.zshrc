source ~/.antigen.zsh

# Load Antigen configurations
antigen init ~/.antigenrc

# case "$TERM" in
    # xterm)
        # export TERM=xterm-256color
        # ;;
    # screen)
        # export TERM=screen-256color
        # ;;
# esac

if [ "$TERM" != "dumb" ]; then
      [ -e "$HOME/.dir_colors" ] && 
      DIR_COLORS="$HOME/.dir_colors" [ -e "$DIR_COLORS" ] ||
      DIR_COLORS="" 
      eval "`dircolors -b $DIR_COLORS`" 
      alias ls='ls --color=auto'
    fi

source ~/.profile

alias tmux="TERM=screen-256color-bce tmux"
alias pip="python -m pip"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source ~/Code/.venv/mainEnv/bin/activate
