#!/usr/bin/env bash

INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

# Install the actual script
cat > "$INSTALL_DIR/key-help" << 'EOF'
#!/usr/bin/env bash

print_bash_shortcuts() {
    # Colors
    local RED="\033[31m"
    local GREEN="\033[32m"
    local BLUE="\033[34m"
    local YELLOW="\033[33m"
    local BOLD="\033[1m"
    local RESET="\033[0m"

    # Header
    printf "${BOLD}${YELLOW}%-15s %-35s %-15s${RESET}\n" "Shortcut" "Description" "Shell"
    printf "%-15s %-35s %-15s\n" "---------------" "-----------------------------------" "---------------"

    # Data
    local data=(
      "CTRL+A CTRL+E" "Go to the start/end of the command line"
      "CTRL+U CTRL+K" "Delete from cursor to the start/end of the command line"
      "CTRL+W OPTION+D" "Delete from cursor to start/end of word (whole word if at the boundary)"
      "CTRL+Y" "Paste word or text that was cut using one of the deletion shortcuts (such as the one above) after the cursor"
      "CTRL+XX" "Move between start of command line and current cursor position (and back again)"
      "OPTION+B OPTION+F" "Move backward/forward one word (or go to start of word the cursor is currently on)"
      "OPTION+C" "Capitalize to end of word starting at cursor (whole word if cursor is at the beginning of word)"
      "OPTION+U" "Make uppercase from cursor to end of word"
      "OPTION+L" "Make lowercase from cursor to end of word"
      "OPTION+T" "Swap current word with previous"
      "CTRL+F CTRL+B" "Move forward/backward one character"
      "CTRL+D CTRL+H" "Delete character after/before under cursor"
      "CTRL+T" "Swap character under cursor with the previous one"
      "CTRL+R" "Search the history backwards"
      "CTRL+J" "End the search at current history entry"
      "CTRL+G" "Escape from history searching mode"
      "CTRL+P" "Previous command in history (i.e., walk back through the command history)"
      "CTRL+N" "Next command in history (i.e., walk forward through the command history)"
      "CTRL+_" "Undo last command"
      "OPTION+." "Use the last word of the previous command"
      "CTRL+L" "Clear the screen"
      "CTRL+S" "Stops the output to the screen (for long running verbose command)"
      "CTRL+Q" "Allow output to the screen (if previously stopped using command above)"
      "CTRL+C" "Terminate the command"
      "CTRL+Z" "Suspend/stop the command"
      "CTRL+V" "Insert a literal next character (useful for typing control chars)"
      "CTRL+O" "Execute command and then fetch next from history"
      "CTRL+M" "Same as Enter/Return"
      "CTRL+I" "Same as Tab (autocomplete / indent)"
      "CTRL+8" "Undo (alias for CTRL+_)"

      "ALT+?" "List possible completions (Zsh only)"
      "ALT+R" "Revert line to original state (discard edits)"
      "TAB + TAB" "Show possible completions (like hitting Tab twice)"
      "*ALT+**" "Insert all possible completions"
      "ALT+DEL" "Delete previous word (like CTRL+W)"
      "ALT+BACKSPACE" "Delete previous word (depending on terminal config)"
      "CTRL+X CTRL+E" "Edit current command in \$EDITOR"
    )

    # Loop through array in chunks of 3 (Shortcut / Description / Shell)
    local i
    for ((i=0; i<${#data[@]}; i+=3)); do
        printf "%-15s %-35s %-15s\n" "${data[i]}" "${data[i+1]}" "${data[i+2]}"
    done
}

if [ -n "$BASH_VERSION" ]; then
  # Put bash hot keys here
  print_bash_shortcuts
  echo -e "\033[32mhello\033[0m"   # green
elif [ -n "$ZSH_VERSION" ]; then
  # Put zsh hot keys here



  echo -e "\033[34mhello\033[0m"   # blue
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
