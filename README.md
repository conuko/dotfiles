# Conuko's Personal Dotfiles

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
│   └── optional/
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

## Optional scripts

Scripts in `bin/optional/` are **not** on `PATH` by default. To opt in, add this to `~/.zshrc.local`:

```bash
export PATH="$DOTFILES_DIR/bin/optional:$PATH"
```

Or symlink individual scripts into `~/.local/bin/` (already on `PATH`):

```bash
ln -s ~/dotfiles/bin/optional/fetch-gitlab-mr-review-comments ~/.local/bin/
```

### fetch-gitlab-mr-review-comments

Writes unresolved review threads from a GitLab merge request into a Markdown file in the directory where the command is run. The output is grouped by file and includes exact `path:line` links.

```bash
fetch-gitlab-mr-review-comments https://gitlab.example.com/group/project/-/merge_requests/42
```

By default, the file is named like `gitlab-mr-review-comments-group-project-mr-42.md`. Use `-o` to choose a custom output path.

```bash
fetch-gitlab-mr-review-comments https://gitlab.example.com/group/project/-/merge_requests/42 -o review-comments.md
```

Requires `glab` on `PATH` with access to the GitLab project.

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
