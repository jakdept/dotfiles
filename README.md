# dotfiles

Your dotfiles are how you personalize your system. These are mine.

## install

On Linux, first you gotta get git or something.

```
apt-get install git
```

On OSX install XCode CLI tools for git:

```
xcode-select --install
```

Finally run the following - there will be some prompts

```
curl https://raw.githubusercontent.com/jakdept/dotfiles/master/bootstrap | bash
```

## components

There's a few special files in the hierarchy.

* **install.d/**: scripts in this folder are run, in order, to set up the system.
  * `*.linux`: is run on linux systems.
  * `*.osx`: is run on macOS.
  * `*.all`: is run on all platforms.
* **repobin/**: Anything in `repobin/` will get added to your `$PATH` and can be run.
* **zshrc.d/\*.zsh**: Loaded/parsed by ZSH on shell startup.
  * `*.zsh`: loaded on both systems.
  * `*.linux`: is linux specific.
  * `*.macos`: is macOS specific.
* **config/**: files in this folder are typically configuration files.
  * `*.symlink`: These files are automatically symlinked to `~/.$1`
* **oh-my-zsh**: created during install, and not maintained as a part of this repo.
* **xorgs**: various `xorg.conf` configurations I've used over time.
