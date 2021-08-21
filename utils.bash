#!/bin/bash
_utils_included=1

# Use debug function to print out values for debugging
# (echo is used for returning values)
# everything will be saved to debug.txt file.

_debug_file="/tmp/data_backup_maker_debug.txt"
function debug
{
    echo "$@" >> "$_debug_file"
}

# Clear debug file before running
echo -n "" > "$_debug_file"

function print_debug
{
    if [ -s "$_debug_file" ]; then
        echo -e "\nDebug:\n$(cat "$_debug_file")"
    fi
}

# Use exit_script function to exit script
# (it's the same as exit but also calls debug).

function exit_script
{
    print_debug
    exit "$@"
}
