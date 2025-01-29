#!/bin/bash

check_github_cli_in_sources() {
    for file in /etc/apt/sources.list.d/*; do
        if [ -f "$file" ] && grep -q "github.cli" "$file"; then
            echo "The string 'github.cli' was found in $file"
            return 0
        fi
    done
    echo "The string 'github.cli' was NOT found in any file in /etc/apt/sources.list.d/"
    return 1
}

check_github_cli_in_sources
