#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# === Install Homebrew ===
echo "[*] Checking Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "    Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add brew to PATH for this session
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "    Homebrew already installed, skipping..."
fi

# === Update Homebrew ===
echo "[*] Updating Homebrew..."
brew update

# === Install core packages ===
echo "[*] Installing packages..."
brew install \
    fzf \
    stow \
    git \
    git-delta \
    bat \
    gh \
    lazygit \
    zoxide

# === Install Go ===
echo "[*] Installing Go..."
GO_VERSION="1.25.6"
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    GO_ARCH="amd64"
elif [ "$ARCH" = "arm64" ]; then
    GO_ARCH="arm64"
else
    echo "    Unsupported architecture: $ARCH"
    exit 1
fi

if ! command -v go &> /dev/null || [ "$(go version | awk '{print $3}')" != "go$GO_VERSION" ]; then
    curl -fsSL "https://go.dev/dl/go${GO_VERSION}.darwin-${GO_ARCH}.tar.gz" -o /tmp/go.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf /tmp/go.tar.gz
    rm /tmp/go.tar.gz
else
    echo "    Go $GO_VERSION already installed, skipping..."
fi

# === Install JetBrains Mono Nerd Font ===
echo "[*] Installing JetBrains Mono Nerd Font..."
if [ ! -f ~/Library/Fonts/JetBrainsMonoNerdFont-Regular.ttf ]; then
    mkdir -p ~/Library/Fonts
    curl -fLo "/tmp/JetBrainsMono.zip" \
        https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
    unzip -o /tmp/JetBrainsMono.zip -d ~/Library/Fonts/
    rm /tmp/JetBrainsMono.zip
else
    echo "    Font already installed, skipping..."
fi

# === Install Ghostty ===
echo "[*] Installing Ghostty..."
if ! command -v ghostty &> /dev/null && [ ! -d "/Applications/Ghostty.app" ]; then
    brew install --cask ghostty
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

# === Install nvm and Node.js ===
echo "[*] Installing nvm..."
export NVM_DIR="$HOME/.config/nvm"
if [ ! -d "$NVM_DIR" ]; then
    mkdir -p "$NVM_DIR"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | PROFILE=/dev/null bash
    # Load nvm for this session
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    echo "[*] Installing Node.js LTS..."
    nvm install --lts
else
    echo "    nvm already installed, skipping..."
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
    chsh -s "$ZSH_PATH"
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
