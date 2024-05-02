#!/bin/sh

git_wrapper() {
    original_command="/usr/bin/git"
    current_dir="$PWD"
    config_file="${XDG_CONFIG_HOME:-$HOME/.config}/git-outta-here.json"
    git_config="$HOME/.gitconfig"

    ORANGE="\033[38;5;208m"
    BLUE="\033[0;34m"
    NC="\033[0m"

    # Fetch the debug setting from the JSON configuration
    debug=$(jq -r '.debug // false' "$config_file")

    # Load the default git configuration
    git_config=$(jq -r '.directories[] | select(.path=="/*") | .config' "$config_file")
    git_config="${git_config/#\~/$HOME}"

    # Find the specific git configuration for the current directory
    jq -c '.directories[]' "$config_file" | while IFS= read -r line; do
        dir_pattern=$(echo "$line" | jq -r '.path')
        config_path=$(echo "$line" | jq -r '.config')

        # Manually expand tilde to home directory
        config_path="${config_path/#\~/$HOME}"

        if echo "$current_dir" | grep -q "$dir_pattern"; then
            git_config="$config_path"
            break
        fi
    done

    export GIT_CONFIG_GLOBAL="$git_config"

    # Conditionally display debug information
    if [ "$debug" = "true" ]; then
        echo -e "${ORANGE}[git-outta-here]${NC}${BLUE}$GIT_CONFIG_GLOBAL${NC}"
        echo ""
    fi

    # Execute the Git command with the dynamically set global configuration
    $original_command "$@"
}

git_wrapper "$@"
