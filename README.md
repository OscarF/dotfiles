# Dotfiles

Sets up a Mac with one command and keeps its configuration in sync across machines: shell (zsh with Oh My Zsh and Starship), git, Homebrew packages and apps, app settings and macOS system settings. Config files are linked into `~` with GNU Stow, so editing them edits the repo. Commit and pull to move changes between machines.

Apple Silicon only: Homebrew's path (`/opt/homebrew`) is hardcoded.

## Install and update

```bash
git clone <your-repo-url> ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

`install.sh` installs Homebrew, Oh My Zsh and everything in the `Brewfile`, links the config files, enables the repo's pre-commit hook, makes Homebrew's zsh your default shell and finishes by running `./test.sh`. Files already in the way are moved to `~/.dotfiles-backup/<timestamp>/`. It's safe to run again, so to update, `git pull` and re-run it. Run `./test.sh` any time to check the setup.

Optional: `./setup/macos_settings` applies macOS system settings (keyboard, trackpad, Dock, Finder, menu bar, window tiling). It restarts the Dock and Finder.

Set your terminal font to **JetBrainsMono Nerd Font** so prompt icons render. In VS Code, add `"terminal.integrated.fontFamily": "JetBrainsMono Nerd Font"` to `settings.json`.

## Machine-specific settings

These files aren't in the repo. Use them for anything personal or tied to one machine:

- **`~/.zshrc.local`**: extra PATH entries, work aliases, environment variables. Loaded at the end of `.zshrc`.
- **`~/.gitconfig.local`**: your git name and email, signing key, and separate work/personal identities (`includeIf`).

Read secrets from the macOS Keychain instead of storing them in plain text:

```bash
# Store once (prompts for the value):
security add-generic-password -a "$USER" -s openai-api-key -w

# In ~/.zshrc.local:
export OPENAI_API_KEY="$(security find-generic-password -a "$USER" -s openai-api-key -w 2>/dev/null)"
```

For GitHub, use `gh auth login`.

## Aliases and functions

| Command | What it does |
|---|---|
| `..`, `...`, `-` | Go up one or two folders, or back to the previous folder |
| `cdf` | Go to the folder open in the front Finder window |
| `ls`, `l`, `ll`, `la`, `lal`, `lsd` | eza listings: grouped, plain, long, hidden files, long + hidden, folders only |
| `pull-all-git-repositories-in-directory [dir]` | Fast-forward pull every repo in a folder, in parallel |
| `gl` | Graph log of all branches. This replaces Oh My Zsh's `gl` (git pull). |
| `gpu` | Push the current branch to origin |
| `git recent` | Recently used branches |
| `git undo` | Undo the last commit, keeping its changes |
| `git amend` | Amend the last commit without editing the message |
| `git fixup <sha>` | Make a fixup commit, squashed in on the next interactive rebase |
| `git sync` | Fetch and rebase onto the default branch |
| `git main` | Print the default branch name |
| `git clean-branches` | Delete local branches merged into the current one |

Oh My Zsh's git plugin adds many more (`gst`, `gd`, `gco` …): see the [plugin's list](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git).

## App settings

Changes you make in Rectangle and LinearMouse show up in the repo automatically. Commit them when you want to take them to your other machines.

- **LinearMouse**: its config file is linked into the repo, so the app writes straight to `apps/`.
- **Rectangle**: its settings are exported to `app-settings/com.knollsoft.Rectangle.plist` whenever they change, by a background agent that `install.sh` sets up. Log: `~/Library/Logs/dotfiles-app-settings.log`.

```bash
./setup/app_settings import          # Apply the repo's Rectangle settings here (e.g. after git pull)
./setup/app_settings export          # Export now (the watcher normally does this)
./setup/app_settings remove-watcher  # Stop watching
```

On a new machine, you still need to give Rectangle Accessibility access (System Settings → Privacy & Security → Accessibility) and check its "Launch on login" setting.

## Uninstall

```bash
cd ~/.dotfiles
./setup/app_settings remove-watcher
stow -D -t ~ zsh git starship apps
chsh -s /bin/zsh   # Optional: back to the macOS zsh
```

Files moved aside during install are in `~/.dotfiles-backup/`.
