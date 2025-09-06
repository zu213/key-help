#!/usr/bin/env bash

set -e

# Determine OS
OS="$(uname -s)"
INSTALL_DIR="$HOME/.local/bin"

if [[ "$OS" == "Linux" || "$OS" == "Darwin" ]]; then
    INSTALL_DIR="$HOME/.local/bin"
else
    INSTALL_DIR="$HOME/bin"
fi

mkdir -p "$INSTALL_DIR"

# ------------------------
# Install Bash/Zsh script
# ------------------------
cat > "$INSTALL_DIR/key-help" << 'EOF'
#!/usr/bin/env bash
if [ -n "$BASH_VERSION" ]; then
    echo -e "\033[32mhello\033[0m"
elif [ -n "$ZSH_VERSION" ]; then
    echo -e "\033[34mhello\033[0m"
else
    echo "hello"
fi
EOF
chmod +x "$INSTALL_DIR/key-help"

# ------------------------
# Install PowerShell script
# ------------------------
PS_SCRIPT="$INSTALL_DIR/key-help.ps1"
cat > "$PS_SCRIPT" << 'EOF'
#!/usr/bin/env pwsh
Write-Host "hello" -ForegroundColor Magenta
EOF

# ------------------------
# Setup Bash/Zsh bindings
# ------------------------
RC_BASH="$HOME/.bashrc"
RC_ZSH="$HOME/.zshrc"

BINDING_SNIPPET='
# key-help function and binding
print_help() {
  local buf
  if [ -n "$BASH_VERSION" ]; then
    buf=$READLINE_LINE
    "'"$INSTALL_DIR"'/key-help"
    READLINE_LINE=$buf
    READLINE_POINT=${#buf}
  elif [ -n "$ZSH_VERSION" ]; then
    buf=$BUFFER
    "'"$INSTALL_DIR"'/key-help"
    BUFFER=$buf
    zle redisplay
  fi
}
if [ -n "$BASH_VERSION" ]; then
  bind -x "\"\C-xh\":print_help\"
fi
if [ -n "$ZSH_VERSION" ]; then
  autoload -Uz zle
  zle -N print_help
  bindkey "^Xh" print_help
fi
'

grep -qxF "$BINDING_SNIPPET" "$RC_BASH" || echo "$BINDING_SNIPPET" >> "$RC_BASH"
grep -qxF "$BINDING_SNIPPET" "$RC_ZSH" || echo "$BINDING_SNIPPET" >> "$RC_ZSH"

# ------------------------
# Setup PowerShell binding
# ------------------------
PS_PROFILE="$HOME/Documents/PowerShell/Microsoft.PowerShell_profile.ps1"
mkdir -p "$(dirname "$PS_PROFILE")"

PS_SNIPPET="
Import-Module PSReadLine
function Invoke-KeyHelp {
    \$line = [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState().Item1
    \$cursor = [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState().Item2
    & \"$PS_SCRIPT\"
    [Microsoft.PowerShell.PSConsoleReadLine]::Replace(0, \$line.Length, \$line)
    [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition(\$cursor)
}
Set-PSReadLineKeyHandler -Chord 'Ctrl+x,h' -ScriptBlock ${function:Invoke-KeyHelp}
"

grep -qxF "$PS_SNIPPET" "$PS_PROFILE" || echo "$PS_SNIPPET" >> "$PS_PROFILE"

echo "✅ Installed key-help for Bash, Zsh, and PowerShell!"
echo "ℹ️  Make sure $INSTALL_DIR is in your PATH and restart your shells."
