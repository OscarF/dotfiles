# AGENTS.md

Notes for changing this repo. Usage is documented in README.md; update it when user-facing behavior changes.

macOS on Apple Silicon only: `/opt/homebrew` is hardcoded on purpose.

## Layout
- Stow packages (linked into `~` by `install.sh`): `zsh/`, `git/`, `starship/`, `apps/`. A new package must be added to the loops in `install.sh` and checked in `test.sh`.
- Not stowed: `setup/` (scripts), `hooks/` (git hooks), `app-settings/` (exported app settings).
- Global gitignore is `git/.config/git/ignore`: stow silently skips files named `.gitignore`.
- Never commit machine-specific values or secrets. They belong in `~/.zshrc.local` / `~/.gitconfig.local` (templates: `*.local.example`), with secrets read from the Keychain.

## Zsh startup (keep it fast)
- `.zshenv` runs for every zsh process, scripts included: cheap exports only.
- `.zprofile` runs `brew shellenv`. It must run after macOS `path_helper` (`/etc/zprofile`), or Homebrew ends up behind `/usr/bin`.
- `.zshrc`: use `$HOMEBREW_PREFIX`, not `$(brew --prefix)`. Completion paths go on `fpath` *before* Oh My Zsh loads, because OMZ runs `compinit`. Never call `compinit` again. fzf comes from the OMZ plugin only.
- `/opt/homebrew/share` must not be group-writable, or OMZ silently drops those completions.

## App settings
- LinearMouse: live symlink, so the app writes straight into `apps/`.
- Rectangle can't be symlinked: it consumes and renames its JSON import file. `setup/app_settings export|import` syncs the `com.knollsoft.Rectangle` defaults domain with `app-settings/*.plist`, filtering out volatile keys. A LaunchAgent (`local.dotfiles.app-settings`) runs `export` on change.

## Checks
- `./test.sh` validates links, tools and config. `install.sh` is safe to run again; it backs up conflicting files to `~/.dotfiles-backup/`.
- Pre-commit (`hooks/`, enabled via `core.hooksPath`): `zsh -n` for zsh files, shellcheck for sh/bash only. Most scripts here are zsh despite the `.sh` extension, and shellcheck doesn't support zsh.
