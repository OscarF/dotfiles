# Setup completions for homebrew packages

if type brew &>/dev/null
then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  fi
fi

if type npm &> /dev/null && [ -f $(npm prefix -g)/lib/node_modules/npm/lib/utils/completion.sh ]; then
  source $(npm prefix -g)/lib/node_modules/npm/lib/utils/completion.sh
fi