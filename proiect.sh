#!/bin/bash

usage() {
    echo "Usage: $0 [--follow-symlinks] <directory>"
    exit 1
}

check_links() {
    local dir="$1"
    local follow_symlinks="$2"
    local visited_dirs=("${visited_dirs[@]}")

    if [[ ! -d "$dir" ]]; then
        echo "Error: '$dir' is not a valid directory or is inaccessible."
        exit 1
    fi

    visited_dirs+=("$(realpath "$dir")")

    for entry in "$dir"/*; do
        if [[ -L "$entry" ]]; then
            target=$(readlink "$entry")
            real_target=$(realpath -m "$entry")

            if [[ ! -e "$entry" ]]; then
                echo "Broken link: $entry -> $target"
            elif [[ "$follow_symlinks" == "true" && -d "$entry" ]]; then
                for visited in "${visited_dirs[@]}"; do
                    if [[ "$real_target" == "$visited"* ]]; then
                        echo "Cycle detected at $entry -> $real_target (prefix match with $visited)."
                        continue 2
                    fi
                done

                visited_dirs+=("$real_target")
                check_links "$entry" "$follow_symlinks"
            fi
        elif [[ -d "$entry" ]]; then
            check_links "$entry" "$follow_symlinks"
        fi
    done
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
    usage
fi

follow_symlinks="false"
if [[ "$1" == "--follow-symlinks" ]]; then
    follow_symlinks="true"
    shift
fi

start_dir="$1"

if [[ -z "$start_dir" ]]; then
    usage
fi

check_links "$start_dir" "$follow_symlinks"
