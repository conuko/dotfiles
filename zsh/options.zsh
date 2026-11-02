HISTFILE="$HOME/.zsh_history"
# HISTSIZE must exceed SAVEHIST for hist_expire_dups_first to have room to work.
HISTSIZE=120000
SAVEHIST=100000

setopt extended_history share_history hist_expire_dups_first hist_ignore_dups
setopt hist_ignore_space hist_verify hist_reduce_blanks

setopt auto_cd auto_pushd pushd_ignore_dups pushd_minus
setopt interactive_comments long_list_jobs no_flow_control
setopt complete_in_word always_to_end

bindkey -e

# Up/Down search history for commands starting with what is already typed.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N edit-command-line

bindkey '^[[A' up-line-or-beginning-search
bindkey '^[OA' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^[OB' down-line-or-beginning-search
bindkey '^X^E' edit-command-line

# Word and line movement with Option/Ctrl + arrows, Home/End and forward delete.
bindkey '^[[1;3C' forward-word
bindkey '^[[1;3D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
