# ~/.zshrc

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

# === zoxide initialization ===
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# === fzf keybindings ===
if command -v fzf &> /dev/null; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh 2>/dev/null || true
    source /usr/share/doc/fzf/examples/completion.zsh 2>/dev/null || true
fi

# === Custom aliases ===
alias lg="lazygit"
alias gs="git status"
alias gd="git diff"

# === Private configs (optional) ===
[[ -f ~/.config/private/work_aliases.zsh ]] && source ~/.config/private/work_aliases.zsh
[[ -f ~/.config/private/api_keys.env ]] && source ~/.config/private/api_keys.env
