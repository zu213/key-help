#!/usr/bin/env bash

data=(
  "Movement" "--------------------------------"
  "CTRL+A CTRL+E" "Go to the start/end of the command line"
  "CTRL+XX" "Alternate cursor position with last position"
  "ALT+B ALT+F" "Move backward/forward one word"
  "CTRL+F CTRL+B" "Move forward/backward one character"

  "Deletion & Pasting" "--------------------------------"
  "CTRL+U CTRL+K" "Delete from cursor to the start/end of the line"
  "CTRL+W ALT+D" "Delete from cursor to start/end of word"
  "CTRL+D CTRL+H" "Delete character after/before under cursor"
  "ALT+BACKSPACE" "Delete previous word"
  "CTRL+Y" "Paste word or text that was cut using a deletion shortcuts"
  
  "Command rejigging" "--------------------------------"
  "OPTION+C" "Capitalize to end of word starting at cursor"
  "OPTION+U" "Make uppercase from cursor to end of word"
  "OPTION+L" "Make lowercase from cursor to end of word"
  "OPTION+T" "Swap current word with previous"
  "CTRL+T" "Swap character under cursor with the previous one"
  "CTRL+I" "Same as Tab (autocomplete / indent)"
  "*ALT+**" "Insert all possible completions"

  "Command searching" "--------------------------------"
  "CTRL+R" "Search the history backwards"
  "CTRL+J" "End the search at current history entry"
  "CTRL+G" "Escape from history searching mode"
  "CTRL+P" "Previous command in history"
  "CTRL+N" "Next command in history"
  "ALT+." "Use the last word of the previous command"
  "TAB + TAB" "Show possible completions"

  "Output control" "--------------------------------"
  "CTRL+L" "Clear the screen"
  "CTRL+S" "Stops the output to the screen"
  "CTRL+Q" "Allow output to the screen (if previously stopped)"

  "Command control" "--------------------------------"
  "CTRL+C" "Terminate the command"
  "CTRL+Z" "Suspend/stop the command"
  "CTRL+V" "Insert a literal next character"
  "CTRL+O" "Execute command and then fetch next from history"
  "CTRL+M" "Same as Enter/Return"
  "CTRL+_ CTRL+8" "Undo last command"
)

print_table() {
    # Colors
    local RED="\033[31m"
    local GREEN="\033[32m"
    local BLUE="\033[34m"
    local YELLOW="\033[33m"
    local BOLD="\033[1m"
    local RESET="\033[0m"

    # Terminal width
    local term_width=$(tput cols)
    local shortcut_width=20
    local desc_width=$((term_width - shortcut_width - 4))

    # Header
    printf "${BOLD}${YELLOW}%-*s %s${RESET}\n" $shortcut_width "Shortcut" "Description"
    printf "%-*s %s\n" $shortcut_width "-------------------" "--------------------------------"

    # Loop through data pairs: Shortcut + Description
    local i
    for ((i=0; i<${#data[@]}; i+=2)); do
        local shortcut="${data[i]}"
        local desc="${data[i+1]}"

        if [[ "${desc:0:1}" == "-" ]]; then
          if [ "$i" -gt 5 ]; then
            echo ""
          fi
          is_header=1
        else
          is_header=0
        fi

        # Wrap description, indent overflow lines
        echo -e "$desc" | fold -s -w $desc_width | \
        awk -v sw=$shortcut_width -v sc="$shortcut" -v reset="$RESET" -v bold="$BOLD" -v green="$GREEN" -v red="$RED" -v header=$is_header '
          NR==1 {
            left_color = (header==1) ? red : green
            right_colour = (header==1) ? red : reset
            printf bold left_color "%-*s %s%s\n", sw, sc, right_colour ,$0
          }
          NR>1 {
            printf bold "%-*s %s%s\n", sw, "", reset, $0
          }
        '
    done
}

if [ -n "$BASH_VERSION" ]; then
  # Put bash hot keys here
  print_table
elif [ -n "$ZSH_VERSION" ]; then
  # Put zsh hot keys here
  data+=(  
    "zsh only" "-------"
    "ALT+?" "List possible completions"
    "ALT+R" "Revert line to original state"
    "ALT+DEL" "Delete previous word (like CTRL+W)"
    "CTRL+X CTRL+E" "Edit current command in \$EDITOR"
  )

  print_table
fi