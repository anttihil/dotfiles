#!/usr/bin/env bash
set -e

# === Update system ===
echo "[*] Updating system..."
sudo apt update && sudo apt upgrade -y

# === Install core packages ===
echo "[*] Installing packages..."
sudo apt install -y \
    fish \
    fzf \
    lazygit \
    stow \
    curl \
    git

# === Install zoxide ===
echo "[*] Installing zoxide..."
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# === Install Helix editor ===
echo "[*] Installing Helix..."
curl -L https://github.com/helix-editor/helix/releases/latest/download/helix-ubuntu.tar.xz \
  | tar -xJ -C /tmp
sudo mv /tmp/helix /usr/local/bin/helix

# === Install Ghostty (example via PPA or build) ===
echo "[*] Installing Ghostty..."
sudo curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh

# === Set fish as default shell ===
echo "[*] Setting fish as default shell..."
chsh -s "$(which fish)"

# === Symlink dotfiles using stow ===
echo "[*] Linking dotfiles..."
DOTFILES_DIR="$HOME/dotfiles"
cd "$DOTFILES_DIR"

for dir in fish helix lazygit fzf zoxide ghostty; do
    stow "$dir"
done

echo "[*] Setup complete!"
