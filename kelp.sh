#!/usr/bin/env bash

INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

# Install the actual script
cp print-keys.sh "$INSTALL_DIR/key-help"

chmod +x "$INSTALL_DIR/key-help"

# Bash binding
if [ -n "$BASH_VERSION" ]; then
  print_help() {
    local buf=$READLINE_LINE
    "$HOME/.local/bin/key-help"
    READLINE_LINE=$buf
    READLINE_POINT=${#buf}
  }
  bind -x '"\C-h":print_help'
fi

# Ensure ~/.local/bin is in PATH
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
  if [ -n "$BASH_VERSION" ]; then
    SHELL_RC="$HOME/.bashrc"
  elif [ -n "$ZSH_VERSION" ]; then
    SHELL_RC="$HOME/.zshrc"
  else
    SHELL_RC="$HOME/.profile" # fallback
  fi

  if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$SHELL_RC" 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
    echo "Added ~/.local/bin to PATH in $SHELL_RC"
  fi
fi

# Zsh binding
if [ -n "$ZSH_VERSION" ]; then
  print_help() {
    local buf=$BUFFER
    "$HOME/.local/bin/key-help"
    BUFFER=$buf
    zle redisplay
  }
  autoload -Uz zle
  zle -N print_help
  bindkey '^Xh' print_help
fi

echo "Successfully installed "key-help", also bound to ctrl+X + h"
