# Login-shell configuration shared by macOS and Linux.
# Homebrew is optional and may live in either standard location.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

[[ -r "$HOME/.zprofile.local" ]] && source "$HOME/.zprofile.local"
