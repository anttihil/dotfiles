# ~/.zshrc

# === PATH setup (before oh-my-zsh so plugins can find binaries) ===
export PATH="$HOME/.local/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin

# === Oh My Zsh configuration ===
export ZSH="$HOME/.oh-my-zsh"

# Theme (robbyrussell is the default, change as desired)
ZSH_THEME="agnoster"

# Plugins
plugins=(
    git
    fzf
    zoxide
    command-not-found
    
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# === General environment ===
export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR=vim
export PAGER=delta
export TERM=xterm-256color

# === Custom aliases ===
alias lg="lazygit"
alias gs="git status"
alias gd="git diff"
if [[ "$(uname)" == "Darwin" ]]; then
    alias cat="bat"
else
    alias cat="batcat"
fi

# === Private configs (optional) ===
[[ -f ~/.config/private/work_aliases.zsh ]] && source ~/.config/private/work_aliases.zsh
[[ -f ~/.config/private/api_keys.env ]] && source ~/.config/private/api_keys.env

# Create worktree + branch from current branch
# Usage: gwn branch-name
gwn() {
  git worktree add -b "$1" "../worktrees/$1" && cd "../worktrees/$1"
}

# Remove worktree and delete branch
# Usage: gwr branch-name
gwr() {
  git worktree remove "../worktrees/$1" && git branch -D "$1"
}

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# === Rust/Cargo (optional) ===
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
