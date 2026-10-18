# Dotfiles

Shared Zsh setup plus the local Ghostty theme. The prompt uses Oh My Zsh's
`robbyrussell` theme, matching the current local Zsh prompt. Ghostty uses
Catppuccin Mocha; since Ghostty renders SSH output locally, that palette also
applies to remote sessions.

## Install with GNU Stow

[GNU Stow](https://www.gnu.org/software/stow/) owns the symlinks. Install Git,
Zsh, and Stow using the host's package manager first. For example:

```sh
# macOS
brew install stow zsh

# Debian/Ubuntu
sudo apt install git stow zsh
```

Clone this repository and install Oh My Zsh if it is not already present:

```sh
git clone https://github.com/maxime-filippini/dotfiles.git ~/.dotfiles
[[ -d ~/.oh-my-zsh ]] || git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
cd ~/.dotfiles
```

### Zsh (every machine)

```sh
stow zsh
exec zsh -l
```

This links `zsh/.zshenv`, `zsh/.zprofile`, and `zsh/.zshrc` into `$HOME`.
Set Zsh as the login shell if desired:

```sh
chsh -s "$(command -v zsh)"
```

### Ghostty (macOS laptop only)

Ghostty runs locally, so do not install this package on an SSH host:

```sh
stow -t "$HOME/Library/Application Support/com.mitchellh.ghostty" ghostty
```

### First-time conflicts

Stow intentionally refuses to overwrite existing files. Back up or inspect a
conflicting file, then rerun the appropriate command. For example:

```sh
mkdir -p ~/.dotfiles-backup
for file in .zshrc .zshenv .zprofile; do
  [[ -e "$HOME/$file" || -L "$HOME/$file" ]] && mv "$HOME/$file" ~/.dotfiles-backup/
done
stow zsh
```

Do not use `stow --adopt` unless you have reviewed the changes it would import
from that machine into this repository.

To remove links later, use `stow -D zsh` (or `stow -D -t "…" ghostty`).

## Ghostty terminfo for SSH

If remote programs report an unknown `xterm-ghostty` terminal, install the
terminfo entry from the laptop (run this locally):

```sh
infocmp -x xterm-ghostty | ssh your-host 'tic -x -o ~/.terminfo /dev/stdin'
```

Do not set `TERM` manually in shell startup files. SSH passes Ghostty's value
through and the terminfo entry lets applications such as tmux and Neovim use
it correctly.

## Per-machine settings

Keep machine-specific paths, tokens, aliases, and tool initialization out of
the repository:

- `~/.zshrc.local` for interactive-shell settings
- `~/.zprofile.local` for login-shell settings

Both are sourced when present and ignored by Git.
