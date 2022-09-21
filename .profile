# Bash Shell only!

# Function to ensure all profile files are able to
# include utility modules when required (and is not
# included twice if already done)
function importutility() {
	if [[ "$2" == "force" ]] || [[ "$2" == "-f" ]] || [[ "$2" == "--force" ]]
	then
		export FORCE_IMPORT_UTILITY=1
	fi
	source $BASH_PROFILE_PATH/utils/$1
	unset FORCE_IMPORT_UTILITY
}

importutility system

# This is your personal file. Add any other custom code
# that you want to execute on startup
export USER_LOCAL_PROFILE=$BASH_PROFILE_PATH/profiles/.personal
system.createfileifdoesnotexist $USER_LOCAL_PROFILE
source $USER_LOCAL_PROFILE

# Load all the other files in the profiles folder.
for filepath in $BASH_PROFILE_PATH/profiles/*; do
	source "$filepath"
	filename=$(basename $filepath)
    # Also set aliases for opening them and refreshing them quickly from the terminal
    # once you edit them.
	alias refresh$filename="source $filepath"
	alias open$filename="texteditor $filepath"
done

# Set aliases for reloading utils
for filepath in $BASH_PROFILE_PATH/utils/*; do
	filename=$(basename $filepath)
	alias refresh$filename="importutility $filename -f"
done
