#!/usr/bin/env bash

print_shortcuts() {
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
        "CTRL+A" "Go to beginning of line" "Bash/Zsh"
        "CTRL+E" "Go to end of line" "Bash/Zsh"
        "CTRL+U" "Kill from cursor to start of line" "Bash/Zsh"
        "CTRL+K" "Kill from cursor to end of line" "Bash/Zsh"
        "CTRL+W" "Kill backward word" "Bash/Zsh"
        "ALT+D" "Kill forward word" "Bash/Zsh"
        "CTRL+Y" "Yank (paste) last killed text" "Bash/Zsh"
        "ALT+T / ESC+T" "Transpose current word with previous" "Bash/Zsh"
        "CTRL+R" "Reverse history search" "Bash/Zsh"
        "CTRL+S" "Forward history search / stop output" "Bash/Zsh"
        "CTRL+C" "Abort current command" "Bash/Zsh"
        "CTRL+Z" "Suspend job" "Bash/Zsh"
        "ALT+." "Insert last word of previous command" "Bash/Zsh"
        "CTRL+L" "Clear screen" "Bash/Zsh"
        "CTRL+X CTRL+E" "Edit command in \$EDITOR" "Bash/Zsh"
        "PowerShell only" "Run kelp.ps1 script" "PowerShell"
    )

    # Loop through array in chunks of 3 (Shortcut / Description / Shell)
    local i
    for ((i=0; i<${#data[@]}; i+=3)); do
        printf "%-15s %-35s %-15s\n" "${data[i]}" "${data[i+1]}" "${data[i+2]}"
    done
}

# Call the function
print_shortcuts
