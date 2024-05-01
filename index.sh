#!/bin/zsh

function git() {
	local original_command="/usr/bin/git"
	local current_dir="$PWD"
	local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/git-outta-here.json"
	local git_config="$HOME/.gitconfig"

	local ORANGE="\033[38;5;208m"
	local BLUE="\033[0;34m"
	local NC="\033[0m"

	# Load the default git configuration
	git_config=$(jq -r '.directories[] | select(.path=="/*") | .config' "$config_file")
	git_config="${git_config/#\~/$HOME}"

	# Find the specific git configuration for the current directory
	while IFS= read -r line; do
		dir_pattern=$(echo "$line" | jq -r '.path')
		config_path=$(echo "$line" | jq -r '.config')

		# Manually expand tilde to home directory
		config_path="${config_path/#\~/$HOME}"

		if [[ "$current_dir" == *"$dir_pattern"* ]]; then
			git_config="$config_path"
			break
		fi
	done < <(jq -c '.directories[]' "$config_file")

	export GIT_CONFIG_GLOBAL="$git_config"

	echo -e "${ORANGE}[git-outta-here]${NC}${BLUE}$GIT_CONFIG_GLOBAL${NC}"
	echo ""

	# Execute the Git command with the dynamically set global configuration
	command $original_command "$@"
}
