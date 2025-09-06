#!/usr/bin/env bash

INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

# Install the actual script
cat > "$INSTALL_DIR/key-help" << 'EOF'
#!/usr/bin/env bash
if [ -n "$BASH_VERSION" ]; then
  echo -e "\033[32mhello\033[0m"   # green
elif [ -n "$ZSH_VERSION" ]; then
  echo -e "\033[34mhello\033[0m"   # blue
else
  echo "hello"
fi
EOF

chmod +x "$INSTALL_DIR/key-help"

# Bash binding
if [ -n "$BASH_VERSION" ]; then
  print_help() {
    local buf=$READLINE_LINE
    "$HOME/.local/bin/key-help"
    READLINE_LINE=$buf
    READLINE_POINT=${#buf}
  }
  bind -x '"\C-xh":print_help'
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

echo "Successfully installed "key-help", also bound to ctrl+X + h
