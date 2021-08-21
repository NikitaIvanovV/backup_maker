#!/bin/bash

src_dir="$(realpath $(dirname $0))/src"
[ -z "$_backup_included" ] && source "$src_dir/backup.bash"
[ -z "$_utils_included" ] && source "$src_dir/utils.bash"


# Name of file containing a list of directories to backup.
# Should be located in the same directory as this script.
backup_list_file="backup_paths_list.txt"

# Directory to store backups in
backup_dir="$(realpath $(dirname $0))/backups"
mkdir -p "$backup_dir"

if ! backup_list=$(get_backup_list "$backup_list_file"); then
    echo "$backup_list"
    exit_script 1
fi

all_names=()

(IFS=$'\n'; for item in $backup_list; do
    name_path=$(get_backup_name_path $item)
    _exit_code=$?
    if [ $_exit_code -eq 0 ]; then
        name=$(echo "$name_path" | head -1)
        path=$(echo "$name_path" | tail -1)
        if [[ "${all_names[*]}" =~ "$name" ]]; then
            echo "Error: name \"$name\" defined multiple times"
            exit_script 1
        fi
        all_names+="$name"
        if output=$(backup_dir "$name" "$path" "$backup_dir"); then
            echo "Backup for \"$name\" ($path) was created successfully"
        else
            echo "$output"
        fi
    elif [ $_exit_code -eq 1 ]; then
        echo "Error: backup list file syntax error: \"$item\""
    else
        echo "Error while getting name and path: \"$item\""
    fi
done; unset IFS )

exit_script 0
