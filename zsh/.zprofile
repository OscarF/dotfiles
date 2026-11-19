# ~/.zprofile - Login shells. Runs after macOS path_helper (/etc/zprofile), so Homebrew stays first in PATH.
eval "$(/opt/homebrew/bin/brew shellenv)"
