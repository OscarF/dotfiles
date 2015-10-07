# export MAKE_OPTS="-j 3"

if type brew &> /dev/null && [ -f $(brew --prefix)/etc/bash_completion ]; then
  source $(brew --prefix)/etc/bash_completion
fi

if type npm &> /dev/null && [ -f $(npm prefix -g)/lib/node_modules/npm/lib/utils/completion.sh ]; then
  source $(npm prefix -g)/lib/node_modules/npm/lib/utils/completion.sh
fi