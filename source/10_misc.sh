# export MAKE_OPTS="-j 3"

# Enable bash completion
if type brew &> /dev/null && [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
  source $(brew --prefix)/share/bash-completion/bash_completion
fi

if type npm &> /dev/null && [ -f $(npm prefix -g)/lib/node_modules/npm/lib/utils/completion.sh ]; then
  source $(npm prefix -g)/lib/node_modules/npm/lib/utils/completion.sh
fi

# Make Tab autocomplete regardless of filename case
set completion-ignore-case on

# List all matches in case multiple possible completions are possible
set show-all-if-ambiguous on

# Immediately add a trailing slash when autocompleting symlinks to directories
set mark-symlinked-directories on

# Be more intelligent when autocompleting by also looking at the text after
# the cursor. For example, when the current line is "cd ~/src/mozil", and
# the cursor is on the "z", pressing Tab will not autocomplete it to "cd
# ~/src/mozillail", but to "cd ~/src/mozilla". (This is supported by the
# Readline used by Bash 4.)
set skip-completed-text on

# Allow UTF-8 input and output, instead of showing stuff like $'\0123\0456'
set input-meta on
set output-meta on
set convert-meta off

# Use the text that has already been typed as the prefix for searching through
# commands (basically more intelligent Up/Down behavior)
if [[ $- == *i* ]]
then
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'

    bind '"\e[5~": history-search-backward'
    bind '"\e[6~": history-search-forward'
fi