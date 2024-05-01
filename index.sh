function my_git() {
	local original_command="git"
	local current_dir="$PWD"
	local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/git-outta-here" # Path to the directory mappings config file
	local git_config="$HOME/.gitconfig"                                  # Default Git config

	local ORANGE="\033[38;5;208m" # ANSI 256-color code for orange
	local BLUE="\033[0;34m"
	local NC="\033[0m" # No Color

	# Read mappings from config file and set the appropriate Git config
	while IFS=' ' read -r dir_pattern config_path; do
		# Manually expand tilde to home directory
		config_path="${config_path/#\~/$HOME}"
		# echo "Read pattern: $dir_pattern with config: $config_path" # Debug output
		if [[ -n "$dir_pattern" && "$current_dir" == *"$dir_pattern"* ]]; then
			git_config="$config_path"
			# echo "Match found: $dir_pattern setting config to $config_path" # Debug output
			break # Stop at the first matching pattern
		fi
	done <"$config_file"

	# Set the global Git configuration environment variable
	export GIT_CONFIG_GLOBAL="$git_config"

	echo -e "${ORANGE}[git-outta-here]${NC} ${BLUE}$GIT_CONFIG_GLOBAL${NC}"
	echo ""

	# Execute the Git command with the dynamically set global configuration
	command $original_command "$@"
}
