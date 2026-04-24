# bash-profile

Personal bash tooling for Onshape and Newton development.

This repository is meant to make the local developer workflow faster and less annoying: starting in the right environment, creating branches correctly, checking whether your environment is actually healthy, building only what you need, managing multiple Newton checkouts, and handling the repetitive Git tasks that otherwise take too much manual work.

## Why use this?

The default Newton workflow has a lot of sharp edges: status checks can be slow or incomplete, it is easy to build from the wrong place, starting or fixing an environment takes multiple commands, and many Git tasks are repetitive. This repo wraps those rough spots in commands that are easier to remember and usually safer to run.

The biggest day-to-day gains are:

1. Start a terminal directly into the correct Newton environment with `initializenewton`.
2. Create correctly named branches from the right base branch with `checkoutfrom*` helpers.
3. Check whether Docker, services, belcad, and quickserve are actually working with `env.check`.
4. Start, stop, repair, and monitor an environment with `env.start`, `env.stopthis`, `env.stopall`, `env.fix`, and `monitorenv`.
5. Run focused builds with `buildjavaonly`, `buildjsonly`, or `buildcpponly` instead of always doing everything.
6. Use Git helpers for backup branches, patch creation, patch application, preserved folder-structure copying, upstream setup, and branch discovery.

## Setup

Clone this repository into your home directory so the folder path becomes `~/bash-profile`:

```bash
cd ~
git clone git@github.com:pisoni-onshape/bash-profile.git
```

Then add this to `~/.profile` or `~/.bash_profile`:

```bash
export BASH_PROFILE_PATH=~/bash-profile
source $BASH_PROFILE_PATH/.profile
```

Open a new terminal, or run:

```bash
source ~/.profile
```

The profile bootstraps the shared functions and also creates a local `profiles/.personal` file for your own aliases and functions.

## macOS Terminal setup for multiple environments

If you use macOS Terminal, create one profile per Newton checkout so each window opens in the correct environment automatically.

For a `Newton` profile:

1. Open Terminal settings and create a profile named `Newton`.
2. In the `Window` tab, set the window title to `Newton`.
3. In the `Shell` tab, enable `Run command` under Startup.
4. Use this startup command:

```bash
cd ~/repos/newton && initializenewton
```

5. Make sure `Run inside shell` is enabled.

This is what it might look like:

<img width="500" alt="newton-terminal-setup" src="https://github.com/pisoni-onshape/bash-profile/assets/87058498/3aa0d8cb-1ef3-4459-9245-ba7d1786b45b">

For additional environments, create more profiles the same way:

```bash
cd ~/repos/newton2 && initializenewton
cd ~/repos/newton3 && initializenewton
```

`initializenewton` figures out which environment you are in and initializes it appropriately.

If you like keyboard-driven switching, you can assign macOS Terminal app shortcuts to these profiles, for example `Ctrl+Shift+1` for `Newton`, `Ctrl+Shift+2` for `Newton2`, and `Ctrl+Shift+3` for `Newton3`.

## First commands to try

After opening a configured Newton terminal, these are good first commands:

```bash
checkoutfromlsbmaster bel-123456/my-change
startServices #Start the docker services for the current environment
buildjavaonly #Build only Java codebase ignoring others (e.g. cpp/js)
startservers #Start the selected servers in the settings (Defaults are Onshape server and grunt serve/quickserve. Can add / remove servers using the 'settings.*' API, e.g. settings.setdebuggingdrawings true ; settings.setusingquickserve false)
openbug #Open the current bug (derived from the branch name in the default browser)
openbugfolder #Create/open a folder for the current bug in the ~/Bugs directory to store files
```

That flow covers the most common first-week tasks: confirm the environment, create a branch correctly, build only what you changed, start the local app, and jump straight to the bug.

## Daily workflow guide

### Branch creation and syncing

Use the branch helpers so the branch name and base branch stay consistent with the later automation:

```bash
# Recommended:
checkoutfromlsbmaster bel-123456/change-summary
checkoutfromlsbrelease bel-123456/change-summary

# Also available:
checkoutfrommaster bel-123456/change-summary
checkoutfromrelease bel-123456/change-summary
```

These commands fetch the latest base branch, create your branch from it, and prepend your username if needed.

When you need to catch up with the branch you started from, use:

```bash
rebaselatest
pulllatest
```

`rebaselatest` rebases your current branch on the correct latest base branch. `pulllatest` does the equivalent pull/merge style update.

### Builds

The build helpers keep you in the right Newton directory, check that Docker is running, and give stronger feedback than a plain manual build.

```bash
buildall
buildjavaonly
buildjsonly
buildcpponly
```

Use `buildall` when you need the full build. Use the language-specific variants when you want faster iteration. Successful and failed builds are announced loudly so you do not need to keep watching the terminal.

### Environment status, start, stop, and repair

One of the strongest parts of this repo is the environment tooling.

```bash
env.check
monitorenv
env.start
env.stopthis
env.stopall
env.fix
```

Use these commands as follows:

1. `env.check` verifies Docker, essential services, belcad, and quickserve, and is much faster for routine checks than the usual manual path.
2. `monitorenv` keeps checking the environment until something stops working, and alerts you. Keep it running in a new terminal.
3. `env.start` starts services and servers for the current environment.
4. `env.stopthis` stops servers and services for only the current environment.
5. `env.stopall` is the broader shutdown path. It stops current servers, stops Docker services, and shuts down Rancher Desktop. At the moment it does not fully stop servers in every other environment, so treat it as a broader cleanup tool rather than a perfect global shutdown.
6. `env.fix` tries to recover a broken local setup automatically.

For direct server control, these are useful too:

```bash
startservers
stopservers
restartservers
areserversrunning
isbelcadrunning
isquickserverunning
quickserve
openbtserver
```

Use them when you want explicit control over belcad and quickserve rather than the broader `env.*` helpers. `openbtserver` opens the current environment's btserver log quickly.

### Bug helpers

```bash
openbug
openbug BEL-123456
openbugfolder
openbugfolder BEL-123456
```

If your branch follows the expected naming convention, `openbug` and `openbugfolder` can infer the bug number automatically. You can also pass a bug number explicitly.

### Git helpers that save time

This repo has many Git helpers. These are the most broadly useful ones to know early.

#### Backup and branch management

```bash
git.backupbranch
git.makecopy
git.setupstream
git.unsetupstream
```

`git.backupbranch` creates a timestamped local backup branch and returns you to the branch you were on. `git.makecopy` creates a working copy branch. `git.setupstream` and `git.unsetupstream` help when a branch needs to be explicitly attached to or detached from a remote upstream.

#### Patch creation and application

```bash
git.patchlatestcommit
git.patchcommit HEAD~2 my-message
git.patchuncommittedchanges my-message
git.patchallchanges my-message
git.applypatch ~/Downloads/some.patch
```

These are useful when you want to move work between machines, send a change quickly, or save a patch before a risky experiment.

#### Copy changed files while preserving folder structure

```bash
git.copyfilesinlatestcommit
git.copyfilesincommit HEAD~1
git.pastefileswithfolderstructure ~/patches/files_with_folder_structure/some-export ~/repos/newton2
```

This is especially useful when you want to move the exact set of changed files into another checkout while preserving the same directory layout.

#### Finding where a file changed

```bash
git.findbrancheswithfilechanges src/main/java/com/example/MyFile.java
```

Use this when you know a file changed somewhere but do not remember which branch carries the relevant work.

## Discover more commands

The README only lists the highest-value commands. There are many more.

The naming is usually a clue:

1. `env.*` for environment orchestration and status.
2. `git.*` for branch, patch, upstream, and search helpers.
3. `system.*`, `string.*`, and `general.*` for reusable utility functions.

Some functions are written as lower-level building blocks for future tooling or for your own personal automation, so not every function is meant to be a polished end-user command. They are still useful once you know the repo a bit better. Feel free to explore all the available functions and aliases to get an idea on how to use them.

Examples of smaller but useful helpers include `system.listallfilesrecursively` for quickly listing every file under a directory, and many other utility functions for string, date-like, system, and general scripting tasks.

## Personal customization

The scripts create a `profiles/.personal` file for you if it doesn't exist. Feel free to add your own functions / aliases in this to keep everything together, and use the library of helpful utility functions with it.

Useful helpers:

```bash
openpersonal
refreshpersonal
```

Typical uses for `.personal` are:

1. Personal aliases that only make sense for you.
2. Functions that combine existing helpers into your own workflow.
3. Custom actions after a successful build.

For example, the repo already calls into personal successful-build hooks if you define them, so you can automatically start servers, open pages, or do any other follow-up that fits your workflow.

## Notes and troubleshooting

1. These commands assume you are working from a Newton checkout and that Docker is available when needed.
2. If a command does not seem to exist after pulling changes, run `refreshprofile`.
3. If you maintain multiple Newton environments, prefer one Terminal profile per checkout rather than manually `cd`-ing around all day.
4. If builds or startup behave strangely, run `env.check` first. It is the fastest way to tell whether Docker, services, belcad, and quickserve are all in a usable state.
5. If the environment is partly broken, try `env.fix` before manually restarting everything.

## Scope of this README

This README is intentionally curated. It highlights the commands most likely to make a Newton developer faster in daily work. The repo exposes many more functions than are listed here, and that is by design.
