alias vim="nvim"
alias dotfiles='cd "$DOTFILES_DIR"'

if command -v eza >/dev/null 2>&1; then
  alias ls="eza --group-directories-first --icons=auto"
  alias ll="eza --group-directories-first --icons=auto --long --git --header"
  alias la="eza --group-directories-first --icons=auto --long --git --header --all"
  alias lt="eza --group-directories-first --icons=auto --tree --level=2"
fi

if command -v bat >/dev/null 2>&1; then
  alias cat="bat --paging=never --style=plain"
fi
