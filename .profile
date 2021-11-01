#Git Completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

export USE_CCACHE=1 #cpp compiler cache
export RELEASE=0 #debug cpp build
export BTI_ENABLE_TIMERS=1 #measure load times in viewer
export XCODEBUILD=1 #enable xcode build
export BTI_DISABLE_HEARTBEATS=1 #So that BSServer doesn't time out so early
export BTI_BLOCK_THUMBNAIL_CPP_SERVER_POOL=1 #if debugging, cut down on the number of BSServers available to attach to
export DEV_TOOLS=/Users/pisoni/repos/onshape-dev-tools
export OBJECT_STORE_REPO_REGION=ap-south-1 #improve artifactory download performance from S3. 
#export HOST_PROPERTIES_PRIVATEIP="$(dockerCreateLoopbackAlias)"


#Startup
cd ~/repos/newton
source buildenv.bash


#Aliases
export ALIAS_PATH=$BASH_PROFILE_PATH
source $ALIAS_PATH/.all
