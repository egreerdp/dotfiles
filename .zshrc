fastfetch 

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source secrets (file ignored by git)
if [ -f ~/.secrets ]; then 
  source ~/.secrets
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
HOMEBREW_NO_ENV_HINTS=true

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias c='clear'
alias cd='z'

# eza
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"

# Lazy
alias lg="lazygit"
alias lzd='lazydocker'

# vim
alias vim='nvim'
alias v='vim' 
alias f='vim $(fzf --preview "bat --style=numbers --color=always {}")'
export EDITOR='vim'


# Docker 
alias dcu='docker compose up -d'
alias dcub='docker compose up --build -d'
alias dcd='docker compose down'
alias dps='docker ps'

alias dk=docker_kill_fzf

docker_kill_fzf() {
  docker kill $(docker ps --format '{{.ID}}\t{{.Image}}\t{{.Names}}' | fzf | awk '{print $1}')
}


# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

bindkey "ç" fzf-cd-widget

# golang
export GOPATH=~/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOPATH/bin
export GOPRIVATE=github.com/dailypay
export GOOS=darwin
export GOARCH=arm64
export CGO_ENABLED=1
export GONOSUMDB=github.com/dailypay/*
unset GOPROXY && unset GOSUMDB

export PATH=$PATH:/Users/ewangreer/Documents/flutter/bin

# core app
export BUNDLE_RUBYGEMS__PKG__GITHUB__COM="${GITHUB_USER}:${GITHUB_TOKEN}"
export BUNDLE_AUTH=$BUNDLE_RUBYGEMS__PKG__GITHUB__COM

# rvm
PATH=$PATH:/.rvm/gems/ruby-3.1.4/bin

# previewing

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude git"

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500; fi" 

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--reverse --preview="bat --style=numbers --color=always --line-range=:500 {}"'
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ACT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in 
    cd) fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'" "$@" ;;
    ssh) fzf --preview 'dig {}' "$@" ;;
    *) fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# app dev
export PATH="/opt/homebrew/opt/node@20/bin:$PATH"
export JAVA_HOME=/opt/homebrew/Cellar/openjdk/22.0.2

export ANDROID_HOME=/Users/ewangreer/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

