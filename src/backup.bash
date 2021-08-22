#!/bin/bash
_backup_included=1

src_dir="$(realpath $(dirname $0))/src"
[ -z "$_utils_included" ] && source "$src_dir/utils.bash"
[ -z "$_config_included" ] && source "$src_dir/config.bash"

function get_backup_list
{
    local root_dir=$(dirname $0)
    local backup_list_file="$root_dir/$1"

    if ! test -f "$backup_list_file"; then
        echo "Error: backup list is not found. It must be located there: \"$(realpath $backup_list_file)\""
        return 1
    fi

    cat $backup_list_file | egrep -v '^#'
}

function get_backup_name_path
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

function get_backup_dir
{
    local dir="$1"
    local name="$2"
    echo "$dir/$name"
}

function backup_dir
{
    local backup_name="$1"
    local path="$2"
    local backup_dir="$(get_backup_dir "$3" "$backup_name")"

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

function clean_backup_dir
{
    if test -z "$max_backups_to_store"; then
        echo "Error: attempting to clean backups when 'max_backups_to_store' variable is not set"
        return 1
    fi

    local backup_name="$1"
    local backup_dir="$(get_backup_dir "$2" "$backup_name")"
    
    local amount=$(ls "$backup_dir" | wc -l)
    
    if [ "$amount" -le "$max_backups_to_store" ]; then
        return 0
    fi

    local num_to_delete
    let "num_to_delete = amount - max_backups_to_store"
    
    local oldest_backup=$(ls -dt $backup_dir/* | tail -$num_to_delete)   
    rm $oldest_backup
}
