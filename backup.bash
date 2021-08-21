#!/bin/bash
_backup_included=1

root_dir=$(realpath $(dirname $0))
[ -z "$_utils_included" ] && source "$root_dir/utils.bash"

function get_backup_list
{
    local root_dir=$(dirname $0)
    local backup_list_file="$root_dir/$1"

    if test -f "$backup_list_file"; then
        cat $backup_list_file | egrep -v '^#'
        return 0
    else
        echo "Error: backup list is not found. It must be located there: \"$(realpath $backup_list_file)\""
        return 1
    fi
}

get_backup_name_path ()
{
    local line="$@"

    local name_pattern='^[\w-]+'
    local path_pattern='[^\\0]+$'
    local line_pattern="${name_pattern} ${path_pattern}"

    if ! echo $line | grep -Pq "$line_pattern"; then
        return 1
    fi

    local res=$(echo "$line" | grep -Po "$name_pattern")
    if test -z "$res"; then
        return 2
    fi
    echo $res
    res=$(echo "$line" | grep -Po '(?<= )'"$path_pattern")
    if test -z "$res"; then
        return 2
    fi
    echo $res
}

function backup_dir
{
    local backup_name=$1
    local path=$2
    local backup_dir="$3/$backup_name"

    local timestamp="$(date -u +%F_%H-%M-%S)"
    local backup_file="$backup_dir/${backup_name}_$timestamp.tar.bz2"

    if ! test -e "$path"; then
        echo "Error: path does not exist: \"$path\""
        return 1
    fi

    mkdir -p "$backup_dir"

    if test -d "$path"; then
        BZIP2=-9 tar -cjf "$backup_file" -C "$path" .
    else
        BZIP2=-9 tar -cjf "$backup_file" -C "$(dirname $path)" "$(basename $path)"
    fi
}
