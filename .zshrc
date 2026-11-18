# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
HIST_STAMPS="mm/dd/yyyy"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan"

plugins=(git tmux zsh-autosuggestions zsh-syntax-highlighting zsh-fzf-history-search)

if [ -x "$(command -v aws)" ]; then
  plugins+=(aws)
  SHOW_AWS_PROMPT=false
fi
if [ -x "$(command -v kubectl)" ]; then
  plugins+=(kubectl)
fi

# nvm: eager loading costs ~600ms per shell, so load it on first use of
# nvm/node/npm/npx/pnpm/yarn/corepack.
# ponytail: node is not on PATH until one of those runs in the shell; add
# globally installed CLIs to `zstyle ':omz:plugins:nvm' lazy-cmd ...` if needed.
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  zstyle ':omz:plugins:nvm' lazy yes
  plugins+=(nvm)
fi

source $ZSH/oh-my-zsh.sh

# User configuration
export EDITOR=nvim
export GPG_TTY=$(tty)
export PATH="$HOME/.opencode/bin:$PATH:/opt/nvim-linux-x86_64/bin"
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

[[ ! -f ~/.bash_aliases ]] || source ~/.bash_aliases
[[ ! -f ~/.bash_functions ]] || source ~/.bash_functions

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Terraform autocompletion (bash-style, hence bashcompinit)
if command -v terraform >/dev/null 2>&1; then
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C "$(command -v terraform)" terraform
fi
