# export MAKE_OPTS="-j 3"

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  source $(brew --prefix)/etc/bash_completion
fi

if [ -f $(npm prefix -g)/lib/node_modules/npm/lib/utils/completion.sh ]; then
    source $(npm prefix -g)/lib/node_modules/npm/lib/utils/completion.sh
fi
