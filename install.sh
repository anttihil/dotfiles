#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# === Update system ===
echo "[*] Updating system..."
sudo apt update && sudo apt upgrade -y

# === Install core packages ===
echo "[*] Installing packages..."
sudo apt install -y \
    zsh \
    fzf \
    lazygit \
    stow \
    curl \
    git \
    delta \
    unzip \
    fontconfig \
    bat /
    gh

# === Install zoxide ===
echo "[*] Installing zoxide..."
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# === Install JetBrains Mono Nerd Font ===
echo "[*] Installing JetBrains Mono Nerd Font..."
if [ ! -f ~/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf ]; then
    mkdir -p ~/.local/share/fonts
    curl -fLo "/tmp/JetBrainsMono.zip" \
        https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/
    fc-cache -fv
    rm /tmp/JetBrainsMono.zip
else
    echo "    Font already installed, skipping..."
fi

# === Install Ghostty ===
echo "[*] Installing Ghostty..."
GHOSTTY_DEB="$DOTFILES_DIR/ghostty_1.2.3-0.ppa1_amd64_trixie.deb"
if ! command -v ghostty &> /dev/null; then
    if [ -f "$GHOSTTY_DEB" ]; then
        sudo dpkg -i "$GHOSTTY_DEB"
        rm "$GHOSTTY_DEB"
    else
        echo "    Ghostty .deb not found, skipping installation..."
    fi
else
    echo "    Ghostty already installed, skipping..."
fi

# === Install Oh My Zsh ===
echo "[*] Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "    Oh My Zsh already installed, skipping..."
fi

# === Install zsh plugins ===
echo "[*] Installing zsh plugins..."
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "    zsh-autosuggestions already installed, skipping..."
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    echo "    zsh-syntax-highlighting already installed, skipping..."
fi

# === Set zsh as default shell ===
echo "[*] Setting zsh as default shell..."
ZSH_PATH="$(which zsh)"
if [ "$SHELL" != "$ZSH_PATH" ]; then
    sudo chsh -s "$ZSH_PATH" "$USER"
    echo "    Default shell changed to zsh. Please log out and back in for this to take effect."
else
    echo "    zsh is already the default shell, skipping..."
fi

# === Backup existing configs ===
echo "[*] Backing up existing configs..."
backup_if_exists() {
    local file="$1"
    if [ -e "$file" ] && [ ! -L "$file" ]; then
        echo "    Backing up $file -> $file.backup"
        mv "$file" "$file.backup"
    fi
}

backup_if_exists ~/.zshrc
backup_if_exists ~/.config/lazygit/config.yaml
backup_if_exists ~/.config/git/config
backup_if_exists ~/.config/ghostty/config

# === Symlink dotfiles using stow ===
echo "[*] Linking dotfiles..."
cd "$DOTFILES_DIR"

for dir in zsh lazygit git ghostty; do
    stow --restow "$dir"
done

echo "[*] Setup complete!"
