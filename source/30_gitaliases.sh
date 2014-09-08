alias gl="git lg --all"
alias gs="git status"
alias gd="git diff"
alias gpr="git pull --rebase"
alias gp="git pull --rebase"
alias gpu="git push origin master"
alias gru="git remote update"
function gc() { git checkout "${@:-master}"; } # Checkout master by default
alias gco='gc'
