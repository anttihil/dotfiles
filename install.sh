#!/usr/bin/env bash
set -e

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
    git

# === Install zoxide ===
echo "[*] Installing zoxide..."
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# === Install Ghostty (example via PPA or build) ===
echo "[*] Installing Ghostty..."
sudo curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh

# === Install Oh My Zsh ===
echo "[*] Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# === Set zsh as default shell ===
echo "[*] Setting zsh as default shell..."
chsh -s "$(which zsh)"

# === Symlink dotfiles using stow ===
echo "[*] Linking dotfiles..."
DOTFILES_DIR="$HOME/dotfiles"
cd "$DOTFILES_DIR"

for dir in zsh lazygit fzf zoxide ghostty; do
    stow "$dir"
done

echo "[*] Setup complete!"
