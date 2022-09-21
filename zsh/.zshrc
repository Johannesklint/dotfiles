
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Fig pre block. Keep at the top of this file.
#. "$HOME/.fig/shell/zshrc.pre.zsh"
# Fig pre block. Keep at the top of this file.

export ZSH="/Users/bia342/.oh-my-zsh"

plugins=(
  git
  zsh-autosuggestions
  zsh-z
)

source $ZSH/oh-my-zsh.sh
ZSH_THEME="powerlevel10k/powerlevel10k"

# ALIAS #
alias zshrc="vim ~/.zshrc"
alias c.='code .'
alias cat='bat'
alias v='vim .'
alias v.='vim .'


alias g='git'
alias gf='git fetch -p'
alias gp='git push'
alias gpu='git pull'
alias pull='git pull'
alias grebase='git rebase origin/main'
alias gst='git status -u'
alias gadd='git add -A'
alias glog='git log'
alias stash='git stash'
alias pop='git stash pop'
alias reset='git reset --hard'
alias ko='git co -'
alias mobile='cd apps/b2c-sales'
alias select='rush select'
alias ri='rush install'
alias rs='rush install && rush select'
alias select='rush select'
alias clean='rush clean && rush update && rush build' 
alias cy='cd apps/b2c-sales && rushx cypress:open'
alias nlint='cd apps/b2c-sales && rushx lint:fix'
alias lint='rushx lint:fix'
alias nlint='npm run lint'

alias typecheck='cd apps/b2c-sales && rushx typecheck'
alias wipe='rush clean && rush update && rush build && rush select'
alias r='rushx'
alias nrb='npm run build'
alias dev='npm run dev'
alias start='npm start'
alias test='rushx test:unit:watch'
alias rf='rm -rf node_modules && npm i'
alias vim='nvim'

# NVM #
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'

export PNPM_HOME="/Users/bia342/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"


export PATH="/usr/local/opt/node@14/bin:$PATH"
export PATH="/usr/local/opt/node@14/bin:$PATH"

# Fig post block. Keep at the bottom of this file.
#

# Fig post block. Keep at the bottom of this file.
#. "$HOME/.fig/shell/zshrc.post.zsh"
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
