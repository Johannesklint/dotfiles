# Prompt

autoload -Uz vcs_info # enable vcs info
precmd () { vcs_info }  # make sure vcs info is loaded before displaying prompt
zstyle ':vcs_info:*' formats ' %b' # format branch name
setopt prompt_subst
export PROMPT='%1~${vcs_info_msg_0_} $ '

# History

# the detailed meaning of the below three variable can be found in `man zshparam`.
export HISTFILE=~/.histfile
export HISTSIZE=1000000   # the number of items for the internal history list
export SAVEHIST=1000000   # maximum number of items for the history file

# The meaning of these options can be found in man page of `zshoptions`.
setopt HIST_IGNORE_ALL_DUPS  # do not put duplicated command into history list
setopt HIST_SAVE_NO_DUPS  # do not save duplicated command
setopt HIST_REDUCE_BLANKS  # remove unnecessary blanks
setopt INC_APPEND_HISTORY_TIME  # append command to history file immediately after execution
setopt EXTENDED_HISTORY  # record command start time

# Variables

export TERM=xterm-256color
export LANG="en-US.UTF-8"
export EDITOR=nvim
export GIT_EDITOR=nvim
export N_PREFIX=$HOME/.local/src/n # Node version manager install directory
export RUST_ROOT=$HOME/.cargo/env
export LOCAL_BIN=$HOME/.local/bin

# Path

if [ $(eval uname) = "Darwin" ]; then
  export BREW_PATH=/opt/homebrew/bin
  export PATH=$BREW_PATH:$PATH
fi

export PATH=$RUST_ROOT:$LOCAL_BIN:$N_PREFIX/bin:$PATH

# ZSH extentions

if [ -f "$HOME/.local/src/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$HOME/.local/src/zsh-autosuggestions/zsh-autosuggestions.zsh"
else
  echo 'zsh-autosuggestions was not found'
fi

if [ -d "$HOME/.local/src/zsh-completions/src" ]; then
  fpath=("$HOME/.local/src/zsh-completions/src" $fpath) # add completions
else
  echo 'zsh-completions was not found'
fi

if [ -f "$HOME/.local/src/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$HOME/.local/src/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
else
  echo 'zsh-syntax-highlighting was not found'
fi

# Programs

# Z
if [ -f "$HOME/.local/src/z/z.sh" ]; then
  source "$HOME/.local/src/z/z.sh"
else
  echo 'z (jump around) was not found'
fi

# FZF

export FZF_DEFAULT_COMMAND='rg --files --hidden'
export FZF_DEFAULT_OPTS='--height=100%'
export MANPATH=$HOME/.local/src/fzf/man:$MANPATH

if [ -f "$HOME/.local/src/fzf/shell/key-bindings.zsh" ]; then
  source "$HOME/.local/src/fzf/shell/key-bindings.zsh"
else
  echo 'fzf key bindings not found'
fi

if [ -f "$HOME/.local/src/fzf/shell/completion.zsh" ]; then
  source "$HOME/.local/src/fzf/shell/completion.zsh"
else
  echo 'fzf completion not found'
fi

# Aliases

alias vil='vim -c "set background=light"'
alias vi='nvim'
alias vim='nvim'
alias reload='. ~/.zshrc'
alias l='ls -al'
alias ll='ls -al'
alias ..='cd ..'
alias ~="cd $HOME"
alias ta='tmux attach'
alias tl='tmux ls'
alias gs='git status'
alias gd='git diff'
alias gl='git log'
alias glo='git log --oneline'
alias gc='git commit'
alias ga='git add'

# Private

[ -f ~/.zsh_private ] && source ~/.zsh_private

# [ -f "/Users/gustaf/.ghcup/env" ] && source "/Users/gustaf/.ghcup/env" # ghcup-envexport PATH="/opt/homebrew/opt/llvm/bin:$PATH"
