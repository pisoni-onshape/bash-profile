#Git Completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

#Startup
cd ~/repos/newton
source buildenv.bash


#Aliases
source $BASH_PROFILE_PATH/.all
