# ~/.config/fish/config.fish

# === General environment ===
set -gx EDITOR helix
set -gx PAGER delta

# === zoxide initialization ===
if type -q zoxide
    zoxide init fish | source
end

# === fzf keybindings ===
if type -q fzf
    fzf_key_bindings
end

# === lazygit integration with delta ===
# (delta is configured via git config, so lazygit picks it up automatically)

# === Ghostty terminal config ===
# Ghostty reads ~/.config/ghostty/config.toml, no shell init needed

# === Custom aliases ===
alias lg="lazygit"
alias gs="git status"
alias gd="git diff"

# === Private configs (optional) ===
if test -f ~/.config/private/work_aliases.fish
    source ~/.config/private/work_aliases.fish
end
if test -f ~/.config/private/api_keys.env
    source ~/.config/private/api_keys.env
end


