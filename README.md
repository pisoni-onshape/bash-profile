# bash-profile
A non-official support repository to assist in Onshape development with various bash functions and aliases.

## Setup
On any new machine, clone this repository to your home directory (such that the **bash-profile** folder is created in the home directory). Something like this on the Terminal should do the job:
```
cd ~
git clone git@github.com:pisoni-onshape/bash-profile.git
```
Then copy these lines in your ~/.profile (or ~/.bash_profile) file if already there (or create one if it doesn't exist). The commands in this file should automatically be executed on Terminal launch.
```
export BASH_PROFILE_PATH=~/bash-profile
source $BASH_PROFILE_PATH/.profile
```
Next, in the macOS Terminal, go to Settings -> Profiles tab, and create a new profile called 'Newton'. You can choose the text, background colors etc. for this profile if you want, but for our purpose:
1. Go to the 'Window' tab of this profile and write 'Newton' as the Window Title.
2. Go to the 'Shell' tab and check 'Run command' under **Startup**
3. Write the following in the textbox for the command to run at startup:
```
cd ~/repos/newton && ensurenewtondirectory
```
This is what it might look like:

 <img width="500" alt="newton-terminal-setup" src="https://github.com/pisoni-onshape/bash-profile/assets/87058498/3aa0d8cb-1ef3-4459-9245-ba7d1786b45b">

4. Check 'Run inside shell' if it's not
5. That's all. If you want to use multi-environment (newton2, newton3 etc.), just create more Terminal Profiles like above, name them accordingly and put the correct directory at startup. For example, for newton2:
```
cd ~/repos/newton2 && ensurenewtondirectory
```
(The command `ensurenewtondirectory` remains the same, it figures out which environment it is and initializes that)

## How to use
When you do the setup as given above, as soon as you open your 'Newton' Terminal it automatically sets the current directory to your newton directory and does `source buildenv.bash` for you, and you should be ready to go. There are many utility functions to use in these scripts. e.g.,
1. Create new branches using `checkoutfromlsbmaster`, `checkoutfromlsbrelease`, `checkoutfrommaster` etc. to automatically create branches from the latest versions of these branches and prepend your username to them
```
checkoutfromlsbmaster bel-<xxxxxx>[/optional-description] # Prepends your username if you don't do it
```
2. Use functions like `buildall`, `buildjavaonly`, `buildjsonly` or `buildcpponly` to build. It verbally announces "Build successful" or "Build failed" and makes the Terminal bounce so that you can switch your attention back to the build if you were doing something else.
1. It also checks you're in the newton directory before building (which sometimes causes confusion as gradle doesn't tell you that), and that docker is running (the official build process can start required services in docker as needed, but doesn't start docker itself if not already running)
1. At any time you can call `mergelatest` or `rebaselatest` to pull or rebase respectively the latest release, master, or lsb/release or lsb/master automatically based on off what you had created your branch of (as long as you used the above `checkoutfrom*` functions)
1. Call `rbtpost` or `rbtupdate` to post to RB Commons. While calling rbtupdate you don't have to find the review request number, it should find that automatically and push to the right one. You also don't have to remember to call `lsb/master...HEAD` or `lsb/rel-*...HEAD` etc. for creating these as it figures it out automatically as well. It also automatically fills the target branch field (master or rel-*) and the Bug field of the RBCommons request if you had created the branch name correctly as instructed in the first step. If you call `setrbtreviewer` with your manager's RBCommons username, it will remember that and add them automatically to every review request as well.
1. When ready to merge after approvals, just call `mergetomaster` or `mergetoreleasethenmaster` depending on what you need. It will create branches if needed, do the necessary checks as required by our Software Release Process (or ask you to confirm them), pull the **approved** RBCommons review request numbers automatically and merge to your required branches. On accidents, you can also call `revertbranchfrommaster` for the same branch that you had merged (follow the instructions and comments) to revert it following the safety rules.
1. Call `git.backupbranch` any time to backup your branch locally with a timestamp and automatically switch back to your current branch (it's not required but if you're paranoid before making any messy changes with your branch it comes in handy). There are similarly many other git related helpful functions like `git.listbranches` or functions to quickly create patch files from your committed/uncommitted or all changes.
1. At any time, you can type functions like `startservers` or `startserversifnotalready` for starting both belcad and `grunt quickServe`. Also, `isbelcadrunning` or `isquickserverunning` are multi-env compatible ways to quickly tell you whether your Onshape server and quickServe are running respectively. There's a shortcut for checking both too : `areserversrunning`.
1. Similarly, there are functions to _quickly_ stop running belcad / quick serve in a multi-env compatible way by calling `fstopbelcad` or `fstopquickserve` or directly `stopservers` and `restartservers` (which will stop and/or restart both belcad and quickServe respectively).
1. It creates a .personal file in the cloned directory's profiles/ directory, where you can put your personal bash aliases and functions. For example, only when the build is successful, the scripts call onsuccessfulbuild function (but don't define it by default). You can define that function in your .personal file what should happen on  a successful build (e.g. in my .personal file I call `startserversifnotalready`, open the browser with the doc that I'm currently working on automatically)
1. Shortcut functions/aliases for many other small tasks (including utilities for string/system/git/rbt), most of them are self explanatory and one can browse through them.
