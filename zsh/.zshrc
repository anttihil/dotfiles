# ~/.zshrc

# === PATH setup (before oh-my-zsh so plugins can find binaries) ===
export PATH="$HOME/.local/bin:$PATH"
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin

# === Oh My Zsh configuration ===
export ZSH="$HOME/.oh-my-zsh"

# Theme (robbyrussell is the default, change as desired)
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
    git
    fzf
    zoxide
    command-not-found
    sudo
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# === General environment ===
export EDITOR=vim
export PAGER=delta
export TERM=xterm-256color

# === Custom aliases ===
alias lg="lazygit"
alias gs="git status"
alias gd="git diff"
alias cat="batcat"

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

eval "$(fzf --zsh)"

# === fzf keybindings ===
if command -v fzf &> /dev/null; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh 2>/dev/null || true
    source /usr/share/doc/fzf/examples/completion.zsh 2>/dev/null || true
fi

# === zoxide initialization ===
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# === Rust/Cargo (optional) ===
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
