PROMPT="%(?:👍 :👎 )"
PROMPT+='%c $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="on %{$fg[cyan]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_CLEAN=""
