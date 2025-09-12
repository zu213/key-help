#!/usr/bin/env bash
# Install the print file in bin
mkdir -p ~/bin
cp print-keys.sh ~/bin/key-help
if [ -n "$BASH_VERSION" ]; then
  SHELL_RC="$HOME/.bashrc"
  PRINT_HELP='
print_help() {
  local buf=$READLINE_LINE
  "$HOME/bin/key-help"
  READLINE_LINE=$buf
  READLINE_POINT=${#buf}
}
bind -x '\''"\C-x\C-h":print_help'\''
'
elif [ -n "$ZSH_VERSION" ]; then
  SHELL_RC="$HOME/.zshrc"
  PRINT_HELP='
print_help() {
  local buf=$BUFFER
  "$HOME/bin/key-help"
  BUFFER=$buf
  zle redisplay
}
zle -N print_help
bindkey "^Xh" print_help
'
else
  SHELL_RC="$HOME/.profile" # fallback
  PRINT_HELP=''
fi
# Ensure ~/bin is in PATH
if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$SHELL_RC" 2>/dev/null; then
  echo 'export PATH="$HOME/bin:$PATH"' >> "$SHELL_RC"
  echo "Added ~/bin to PATH in $SHELL_RC"
fi
# Add hotkey binding if missing
if [ -n "$PRINT_HELP" ] && ! grep -q 'print_help' "$SHELL_RC" 2>/dev/null; then
  printf "%s" "$PRINT_HELP" >> "$SHELL_RC"
  echo "Added keybinding to $SHELL_RC"
fi
# Apply PATH immediately for current session
export PATH="$HOME/bin:$PATH"
# Bash binding for hotkey immediately
if [ -n "$BASH_VERSION" ] || [ -n "$ZSH_VERSION" ]; then
  eval "$PRINT_HELP"
fi
echo "Successfully installed \"key-help\", also bound to ctrl+x+h"