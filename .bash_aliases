#################
#   Bash Alias  #
#################

# Basics
alias py='python3'
alias cls='clear'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ips='ip -br -c a'
alias myip='echo $(curl -s ifconfig.me)'
alias myip4='echo $(curl -4 -s ifconfig.me)'
alias vi='nvim'
alias ai-usage='npx ccusage@latest'

# Random number generator
rand() {
    local len="${1:-32}"
    LC_ALL=C tr -dc 'A-Za-z0-9' < /dev/urandom | head -c "$len"; echo
}

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  #alias dir='dir --color=auto'
  #alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi


# Docker
alias d='docker'
alias dc='docker compose'
alias ds='docker stop $(docker ps -aq)'
alias drm='docker container prune'   # stopped containers only, asks first
alias drmi='docker image prune -a'    # unused images only, asks first

# Kubernetes
alias kb='kubectl'
alias kbd='kubectl run debug-pod --rm -it --image=sat599/debugger:latest --restart=Never -- bash'

# DevOps
alias tf='terraform'
