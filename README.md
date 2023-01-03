# bash-profile
A non-official support repository to assist in Onshape development with various bash functions and aliases.

## Setup
On any new machine, clone this repository to your home directory (such that the **bash-profile** folder is created in the home directory). Something like this on the Terminal should do the job:

    cd ~
    git clone git@github.com:pisoni-onshape/bash-profile.git

Then copy these lines in one of your ~/.profile, or ~/.bash_profile files if already there (or create one if not):

    export BASH_PROFILE_PATH=~/bash-profile
    source $BASH_PROFILE_PATH/.profile

## How to use
There are many utility functions to use in these scripts. e.g.,
1. Create new branches using checkoutfromlsbmaster, checkoutfromlsbrelease, checkoutfrommaster etc. to automatically create branches from the latest versions of these branches and prepend your username to them
    checkoutfromlsbmaster bel-<xxxxxx>[/optionaldescription]
1. Use functions like buildall, buildjavaonly, buildjsonly or buildcpponly to build. It verbally announces "Build successful" or "Build failed" so that you can switch your attention back to the build if you were doing something else.
1. It also checks you're in newton directory before building (which sometimes causes confusion as gradle doesn't tell you that), and that docker is running (the official build process can start requried services in docker as needed, but doesn't start docker itself if not already running)
1. Call rbtpost or rbtupdate to post to RB Commons. While calling rbtupdate you don't have to find the review request number, it should find that automatically and push to the right one.
1. When ready, just call mergetomaster or mergetoreleasethenmaster depending on what you need. It will create branches if needed, do the necessary checks as required by our Software Release Process (or ask you to confirm them), pull the **approved** RBCommons review request numbers automatically and merge to your required branches.
1. Call git.backupbranch any time to backup your branch locally with a timestamp and switch back to your current branch (it's not required but if you're paranoid before making any messy changes with your branch it comes in handy)
1. It creates a .personal file in the cloned directory's profiles/ directory, where you can put your personal bash aliases and functions.
1. Shortcut functions/aliases for many other small tasks (including utilities for string/system/git/rbt), most of them are self explanatory and one can browse through them.
