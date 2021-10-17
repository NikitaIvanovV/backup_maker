#!/usr/bin/env bash
_config_included=1


config_path="$(realpath $(dirname "$0"))/settings.conf"

# Default values
max_backups_to_store=  # Empty means do not delete backups 

test -e "$config_path" && source "$config_path"
