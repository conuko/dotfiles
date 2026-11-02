# Conuko's Personal Dotfiles

My personal and opinionated macOS dotfiles, adapted from the general structure and workflow ideas in [`necolas/dotfiles`](https://github.com/necolas/dotfiles) but scoped to the tools and settings actually used on my machine.

## What's managed

- `zsh` configuration without a framework: Homebrew plugins (autosuggestions, syntax highlighting, completions), a [Starship](https://starship.rs) prompt, [fzf](https://github.com/junegunn/fzf), [zoxide](https://github.com/ajeetdsouza/zoxide), and `eza`/`bat`/`fd` aliases
- Language runtimes with [mise](https://mise.jdx.dev) (Node, pnpm, Bun, Python, Go, Yarn, Poetry), including automatic switching from `.nvmrc`, `.node-version`, `.python-version` and `.ruby-version`
- Git config with current defaults, [delta](https://github.com/dandavison/delta) for diffs, and SSH commit signing
- [Ghostty](https://ghostty.org) terminal config
- Homebrew packages via `Brewfile`
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
├── bin/          bootstrap, link, update, macos
│   └── optional/ opt-in helper scripts
├── ghostty/      → ~/.config/ghostty/config.ghostty
├── git/          → ~/.config/git/config, ~/.config/git/ignore
├── local/        templates for untracked machine-local files
├── macos/
├── mise/         → ~/.config/mise/config.toml
├── starship/     → ~/.config/starship.toml
└── zsh/          → ~/.zshrc, ~/.zprofile
```

## Commands

The scripts are not on `PATH`; call them by path.

### Bootstrap a machine

Installs Homebrew and the tracked packages, links managed dotfiles, creates missing local files, installs mise from [mise.run](https://mise.run) along with its runtimes, and optionally applies macOS defaults. On a fresh Mac, install Apple's command-line tools first (`xcode-select --install`) so `git` is available to clone this repo; the Homebrew installer then asks once for your password and for Enter to continue.

```bash
~/dotfiles/bin/bootstrap
~/dotfiles/bin/bootstrap --macos
```

### Relink managed dotfiles

Safely backs up conflicting existing files in `~/.dotfiles-backups/<timestamp>/`, keeping their path relative to `~`. Running it again changes nothing.

```bash
~/dotfiles/bin/link
```

### Apply macOS defaults only

```bash
~/dotfiles/bin/macos
```

### Update everything

Pulls the repo (`--ff-only`), upgrades Homebrew packages, mise itself (`mise self-update`) and its runtimes, upgrades `gh` extensions, relinks, and lists installed packages that no Brewfile mentions.

```bash
~/dotfiles/bin/update
```

## Managed home files

| Home file | Repo file |
| --- | --- |
| `~/.zshrc` | `zsh/zshrc` |
| `~/.zprofile` | `zsh/zprofile` |
| `~/.config/git/config` | `git/gitconfig` |
| `~/.config/git/ignore` | `git/gitignore` |
| `~/.config/mise/config.toml` | `mise/config.toml` |
| `~/.config/starship.toml` | `starship/starship.toml` |
| `~/.config/ghostty/config.ghostty` | `ghostty/config.ghostty` |

## Local overrides

These files are intentionally outside the repo and are safe for machine-specific or private values:

- `~/.gitconfig`: identity, signing key, and anything `git config --global` writes. Git reads it after `~/.config/git/config`, so its values win.
- `~/.zshrc.local`: sourced at the end of `~/.zshrc`
- `~/.config/git/allowed_signers`: lets git verify your own SSH signatures
- `~/dotfiles/Brewfile.local`: extra packages for this machine (git-ignored)

Bootstrap creates the first two from `local/gitconfig.example` and `local/zshrc.local.example` when missing, and generates `allowed_signers` from `user.email` and `~/.ssh/id_ed25519.pub`.

## Commit signing

Commits and tags are signed with SSH (`gpg.format = ssh`). On a new machine:

1. Set `user.name`, `user.email` and `user.signingkey = ~/.ssh/id_ed25519.pub` in `~/.gitconfig`.
2. Run `~/dotfiles/bin/bootstrap` (or create `~/.config/git/allowed_signers` yourself).
3. Add the public key as a **signing** key on GitHub (`gh ssh-key add ~/.ssh/id_ed25519.pub --type signing`) and on GitLab (key usage "Authentication & Signing").

## Shell shortcuts

### Keys

| Keys | What it does |
| --- | --- |
| `Ctrl-R` | Fuzzy-search your command history (fzf) |
| `Ctrl-T` | Fuzzy-find a file below the current directory and insert its path, with a `bat` preview |
| `Alt-C` | Fuzzy-find a directory below the current one and `cd` into it |
| `**` then `Tab` | Fuzzy completion: `vim **<Tab>` for files, `cd src/**<Tab>` for directories, `kill **<Tab>` for processes, `ssh **<Tab>` for hosts |
| `Tab` | Completion menu with case-insensitive matching; move through it with the arrow keys |
| `↑` / `↓` | Step through earlier commands that start with what you have typed |
| `→` or `End` | Accept the grey autosuggestion; `Option-→` accepts one word of it |
| `Option-←` / `Option-→` | Move one word left or right (`Ctrl-←` / `Ctrl-→` work too) |
| `Ctrl-X Ctrl-E` | Edit the current command in Neovim |

`Alt` is the left `Option` key in Ghostty (`macos-option-as-alt = left`). In iTerm, set the left Option key to "Esc+" under Profiles → Keys.

### Commands

| Command | What it does |
| --- | --- |
| `z <part of a path>` | Jump to the most-used directory that matches (zoxide) |
| `zi <part of a path>` | Pick from the matching directories with fzf |
| `<directory>` | Typing a directory name on its own `cd`s into it |
| `cd -<Tab>` | Pick from recently visited directories |
| `ls`, `ll`, `la`, `lt` | eza: list, long list with git status, long list including hidden files, tree two levels deep |
| `cat <file>` | `bat` with syntax highlighting. Use `\cat` for the original: `bat` rejects flags such as `cat -v` |
| `man <command>` | Man pages are colored by `bat` |
| `vim` | Neovim |
| `dotfiles` | `cd` into this repo |
| `git diff`, `git show`, `git add -p` | Output goes through delta; `n` and `N` jump between files |

## Runtimes with mise

Global versions live in `mise/config.toml`. In a project, mise reads `mise.toml` or the version files of other managers (`.nvmrc` and friends) and switches versions when you `cd` into it, so there is no `nvm use` step.

```bash
mise install          # install everything the current directory needs
mise use node@22      # pin a version for the current project (writes mise.toml)
mise ls               # show installed and active versions
mise doctor           # check the setup
```

Interactive shells use `mise activate`. Login shells started by GUI apps and editors get the mise shims through `~/.zprofile`.

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

## Brewfile scope

The tracked `Brewfile` contains the core daily tools, grouped by purpose: Git (`git`, `git-lfs`, `git-delta`, `gh`, `glab`, `lazygit`), shell (`starship`, zsh plugins, `fzf`, `zoxide`, `eza`, `bat`, `fd`, `ripgrep`, `jq`), development (`uv`, `neovim`, `shellcheck`), media and web (`ffmpeg`, `svgo`, `mkcert`), and the Ghostty cask. Language runtimes come from mise, not Homebrew. mise itself is installed from [mise.run](https://mise.run) into `~/.local/bin`, because the official binary is smaller and faster than Homebrew's build and can update itself.

Put extra machine-local packages in the untracked `Brewfile.local`; `bin/bootstrap` and `bin/update` load it when it exists.

## CI

`.github/workflows/lint.yml` runs ShellCheck on the scripts and syntax-checks the zsh and Python files on every push.
