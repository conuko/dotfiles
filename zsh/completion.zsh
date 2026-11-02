# Homebrew's site-functions are added in path.zsh; this adds zsh-completions.
if [[ -n "${HOMEBREW_PREFIX:-}" && -d "$HOMEBREW_PREFIX/share/zsh-completions" ]]; then
  fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)
fi

zmodload zsh/complist
autoload -Uz compinit

# Rebuild and security-check the completion dump at most once a day. -i skips insecure
# entries instead of prompting; Homebrew's group-writable share/ would otherwise trigger it.
() {
  setopt local_options extended_glob
  local dump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"
  [[ -d "${dump:h}" ]] || mkdir -p "${dump:h}"

  if [[ -f "$dump" && -z $dump(#qN.mh+24) ]]; then
    compinit -C -d "$dump"
  else
    compinit -i -d "$dump"
    touch "$dump"
  fi
}

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}%d%f'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/compcache"
