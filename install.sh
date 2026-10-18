#!/usr/bin/env bash
# Install shared terminal configuration. Safe to run on macOS or Linux.
set -euo pipefail

repo_dir="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
backup_dir="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

link() {
  local source=$1 destination=$2
  mkdir -p "$(dirname "$destination")"
  if [[ -L "$destination" && "$(readlink "$destination")" == "$source" ]]; then
    return
  fi
  if [[ -e "$destination" || -L "$destination" ]]; then
    mkdir -p "$backup_dir"
    mv "$destination" "$backup_dir/$(basename "$destination")"
  fi
  ln -s "$source" "$destination"
}

link "$repo_dir/zsh/.zshenv" "$HOME/.zshenv"
link "$repo_dir/zsh/.zprofile" "$HOME/.zprofile"
link "$repo_dir/zsh/.zshrc" "$HOME/.zshrc"

# Ghostty only runs locally. This is its macOS configuration location.
if [[ "$(uname)" == Darwin ]]; then
  link "$repo_dir/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
fi

if ! command -v zsh >/dev/null 2>&1; then
  echo "Install zsh, then rerun this script." >&2
  exit 1
fi

if [[ ! -r "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
  if command -v git >/dev/null 2>&1; then
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  else
    echo "Oh My Zsh was not installed (git is unavailable)." >&2
  fi
fi

if [[ -d "$backup_dir" ]]; then
  echo "Existing files were backed up to $backup_dir"
fi
echo "Installed dotfiles from $repo_dir"
