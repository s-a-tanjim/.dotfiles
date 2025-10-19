#################
#   Bash Alias  #
#################

# Basics
alias py2='python2'
alias py='python3'
alias cls='clear'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ips='ip -br -c a'
alias myip='echo $(curl -s ifconfig.me)'
alias vi='nvim'

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
alias drm='docker stop $(docker ps -aq) && docker rm $(docker ps -aq)'
alias drmi='docker rmi $(docker images -aq)'

# Kubernetes
alias kb='kubectl'

# DevOps
alias tf='terraform'
