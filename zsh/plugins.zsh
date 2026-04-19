plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source "$ZSH/oh-my-zsh.sh"

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  . "$NVM_DIR/nvm.sh"
fi

if [[ -s "$NVM_DIR/bash_completion" ]]; then
  . "$NVM_DIR/bash_completion"
fi

if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init - --no-rehash)"
fi

if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init - zsh)"
fi

if [[ -o interactive ]] && command -v gh >/dev/null 2>&1; then
  eval "$(gh copilot alias -- zsh 2>/dev/null)" || true
fi
