#!/bin/bash

echo "🔄 Restoring Neovim configuration for Arch Linux..."

# Step 1: Install Neovim
echo "📦 Installing Neovim and dependencies..."
sudo pacman -Syu --noconfirm neovim git unzip curl

# Step 2: Create config directory
echo "📁 Creating config directories..."
mkdir -p ~/.config/nvim
mkdir -p ~/.local/share/nvim
mkdir -p ~/.cache/nvim

# Step 3: Copy config files
echo "📂 Copying config files..."
cp -r ./nvim ~/.config/
cp -r ./nvim-data ~/.local/share/nvim 2>/dev/null || true
cp -r ./nvim-cache ~/.cache/nvim 2>/dev/null || true

echo "✅ Neovim config restored successfully!"

