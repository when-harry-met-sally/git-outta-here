#!/bin/zsh

function git_wrapper() {
    local original_command="/usr/bin/git"
    local current_dir="$PWD"
    local git_config="$HOME/.gitconfig"
    local config_json="$GIT_CONFIG_JSON"
    local log_file="$HOME/.git-outta-here-log"

    # Process JSON once to get configurations and debug setting
    local configs=$(echo "$config_json" | jq -r '.directories[] | "\(.path) \(.config)"')
    local debug=$(echo "$config_json" | jq -r '.debug // false')

    while IFS=' ' read -r dir_pattern config_path; do
        config_path="${config_path/#\~/$HOME}"  # Expand tilde

        if [[ "$current_dir" == *"$dir_pattern"* ]]; then
            git_config="$config_path"
            break
        fi
    done <<< "$configs"

    export GIT_CONFIG_GLOBAL="$git_config"

    # Call debug logging with current context
    log_debug "$debug" "$current_dir" "$git_config" "$log_file"

    # Execute the Git command
    command $original_command "$@"
}

function log_debug {
    local debug=$1
    local current_dir=$2
    local git_config=$3
    local log_file=$4

    [[ "$debug" == true ]] || return

    # Run the entire log operation in the background
    {
        # Buffer the log output
        local log_output="Debug Info: $(date)\nCurrent Directory: $current_dir\nGit Configuration Applied: $git_config\n-----------------------------------\n"

        # Append new log to the file
        echo "$log_output" >> "$log_file"

        # Ensure log file does not exceed 100 characters
        # This uses tail to keep only the last 100 characters of the log file
        local log_content=$(tail -c 100 "$log_file")
        echo "$log_content" > "$log_file"
    } &
}

git_wrapper "$@"
