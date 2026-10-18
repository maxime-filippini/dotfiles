# Shared interactive Zsh configuration. Put machine-specific settings in
# ~/.zshrc.local; it is deliberately not tracked.

[[ -o interactive ]] || return

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)

# Oh My Zsh is installed by ./install.sh. Keep a usable shell if it is absent.
if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  autoload -Uz compinit
  compinit
fi

# Optional tools: enable them only on hosts where they are installed.
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
[[ -r "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
