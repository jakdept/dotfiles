# holman does dotfiles

## dotfiles

Your dotfiles are how you personalize your system. These are mine.

If you want to read some ranting on this subject, [check this out](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/).

## install

For now, download the repo, unpack it somewhere, and run the install script.

## components

There's a few special files in the hierarchy.

- **install.d/**: scripts in this folder are run, in order, to set up the system.
 - `\*.linux`: is run on linux systems.
 - `\*.osx`: is run on macOS.
 - `\*.all`: is run on all platforms.
- **repobin/**: Anything in `repobin/` will get added to your `$PATH` and can be run.
- **zshrc.d/\*.zsh**: Loaded/parsed by ZSH on shell startup.
 - `\*.zsh`: loaded on both systems.
 - `\*.linux`: is linux specific.
 - `\*.macos`: is macOS specific.
- **config/**: files in this folder are typically configuration files.
 - `\*.symlink`: These files are automatically symlinked to `~/.$1`
- **oh-my-zsh**: created during install, and not maintained as a part of this repo.
- **xorgs**: various `xorg.conf` configurations I've used over time.
