# Conukos Personal Dotfiles

My personal and opinionated macOS dotfiles, adapted from the general structure and workflow ideas in [`necolas/dotfiles`](https://github.com/necolas/dotfiles) but scoped to the tools and settings actually used on my machine.

## What's managed

- `zsh` configuration with `oh-my-zsh`, `powerlevel10k`, `nvm`, `pyenv`, `rbenv`, `pnpm`, `pipx`, and GitHub Copilot shell aliases
- Git config and global gitignore
- Homebrew package bootstrap via `Brewfile`
- Safe macOS defaults

## What's not managed

- Secrets, SSH keys, tokens, or personal identity settings
- Neovim config
- Project-specific tooling beyond the curated Brewfile
- Highly personal macOS UI tweaks

## Repository layout

```text
dotfiles/
├── Brewfile
├── bin/
├── git/
├── local/
├── macos/
└── zsh/
```

## Commands

### Bootstrap a machine

Runs Homebrew setup, installs the tracked packages, creates missing local override files, links managed dotfiles, and optionally applies macOS defaults.

```bash
~/dotfiles/bin/bootstrap
~/dotfiles/bin/bootstrap --macos
```

### Relink managed dotfiles

Safely backs up conflicting existing files in `~/.dotfiles-backups/<timestamp>/`.

```bash
~/dotfiles/bin/link
```

### Apply macOS defaults only

```bash
~/dotfiles/bin/macos
```

### Update the repo and re-apply config

If the repository has an `origin` remote, this pulls with `--ff-only` before refreshing packages and links.

```bash
~/dotfiles/bin/update
```

## Managed home files

- `~/.zshrc` -> `~/dotfiles/zsh/zshrc`
- `~/.gitconfig` -> `~/dotfiles/git/gitconfig`
- `~/.gitignore` -> `~/dotfiles/git/gitignore`

## Local overrides

These files are intentionally outside the repo and are safe for machine-specific or private values:

- `~/.gitconfig.local`
- `~/.zshrc.local`

Bootstrap creates them from these templates when missing:

- `~/dotfiles/local/gitconfig.local.example`
- `~/dotfiles/local/zshrc.local.example`

## Brewfile scope

The tracked `Brewfile` contains the core daily tools for my machine:

- `git`
- `gh`
- `gnupg`
- `diff-so-fancy`
- `neovim`
- `ripgrep`
- `jq`
- `lazygit`
- `node`
- `pnpm`
- `bun`
- `pyenv`
- `rbenv`
- `pipx`
- `go`
- `ffmpeg`
- `svgo`
- `mkcert`

If you want extra machine-local packages later, add them to a non-tracked `Brewfile.local` and keep the tracked file curated.

`bin/bootstrap` and `bin/update` also load `~/dotfiles/Brewfile.local` when it exists.
