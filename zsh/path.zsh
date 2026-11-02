typeset -U path fpath

# Static equivalent of `brew shellenv`, which costs ~100 ms on every shell start.
if [[ -x /opt/homebrew/bin/brew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_REPOSITORY="/opt/homebrew"
elif [[ -x /usr/local/bin/brew ]]; then
  export HOMEBREW_PREFIX="/usr/local"
  export HOMEBREW_REPOSITORY="/usr/local/Homebrew"
fi

if [[ -n "${HOMEBREW_PREFIX:-}" ]]; then
  export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
  export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}"
  path=("$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin" $path)
  fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
fi

path=("$HOME/.local/bin" "$PNPM_HOME" $path)
