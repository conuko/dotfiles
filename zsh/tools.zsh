# Every `eval "$(tool init)"` forks a process, which adds up to ~100 ms per shell.
# Cache each generated script, keyed by the tool's resolved binary path and its
# modification time, so an upgrade (`brew upgrade`, `mise self-update`) regenerates it.
zmodload -F zsh/stat b:zstat

_cached_init() {
  local name="$1" bin="${commands[$2]}"
  shift 2
  [[ -n "$bin" ]] || return 1

  local -a mtime
  zstat -A mtime +mtime -- "${bin:A}" || return 1

  local dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/init"
  local cache="$dir/$name-${${bin:A}//\//_}-${mtime[1]}.zsh"

  if [[ ! -s "$cache" ]]; then
    [[ -d "$dir" ]] || mkdir -p "$dir"
    rm -f "$dir/$name-"*.zsh(N)
    "$@" >| "$cache" 2>/dev/null || { rm -f "$cache"; return 1; }
  fi

  source "$cache"
}

_cached_init mise mise mise activate zsh
_cached_init starship starship starship init zsh --print-full-init
_cached_init zoxide zoxide zoxide init zsh

if (( $+commands[fzf] )); then
  if (( $+commands[fd] )); then
    export FZF_DEFAULT_COMMAND="fd --type file --hidden --follow --exclude .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND="fd --type directory --hidden --follow --exclude .git"
  fi

  if (( $+commands[bat] )); then
    export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"
  fi

  _cached_init fzf fzf fzf --zsh
fi

if (( $+commands[bat] )); then
  export MANPAGER="sh -c 'col -bx | bat --language=man --plain'"
fi

unfunction _cached_init
