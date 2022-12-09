source "${HOME}/.zgenom/zgenom.zsh"
if ! zgenom saved; then
  zgenom oh-my-zsh
  # Load async plugin
  zgenom load mafredri/zsh-async

  # Load some oh-my-zsh plugins
  zgenom oh-my-zsh plugins/pip #pip autocompletion
  zgenom oh-my-zsh plugins/sudo #prefix with sudo by typing 2xESC
  zgenom oh-my-zsh plugins/z #add awesome z directory navigation script
  zgenom oh-my-zsh plugins/colored-man-pages #duh
  zgenom oh-my-zsh plugins/git #many git aliases
  #zgenom oh-my-zsh plugins/python #python aliases
  zgenom oh-my-zsh plugins/vi-mode #edit the command with vim
  zgenom oh-my-zsh plugins/systemd #systemd aliases
  zgenom oh-my-zsh plugins/common-aliases #common aliases like ll, la etc...
  zgenom oh-my-zsh plugins/docker #completion and aliases for docker
  zgenom oh-my-zsh plugins/docker-compose #completion and aliases for docker-compose
  zgenom oh-my-zsh plugins/fzf #fuzzy autocompletion and keybindings
  # zgenom oh-my-zsh plugins/tmux

  # Dracula theme
  # zgenom load dracula/zsh

  # Tab complete rakefile targets
  # zgenom load unixorn/rake-completion.zshplugin

  # Automatically run zgenom update and zgen selfupdate every 7 days
  zgenom load unixorn/autoupdate-zgen

  # Add my random utility functions
  zgenom load unixorn/jpb.zshplugin

  # Colorize the things if you have grc installed. Well, some of the
  # things, anyway.
  zgenom load unixorn/warhol.plugin.zsh

  # OS X helpers. This plugin is smart enough to detect when it isn't running
  # on OS X and not load itself, so you can safely share the same plugin list
  # across OS X and Linux/BSD
  zgenom load unixorn/tumult.plugin.zsh

  # Warn you when you run a command that you've set an alias for
  zgenom load djui/alias-tips

  # Add my collection of git helper scripts
  zgenom load unixorn/git-extra-commands

  # Add my bitbucket git helpers plugin
  # zgenom load unixorn/bitbucket-git-helpers.plugin.zsh

  # A collection of scripts that might be useful to sysadmins
  zgenom load skx/sysadmin-util

  # Adds aliases to open your current repo & branch on github.
  # zgenom load peterhurford/git-it-on.zsh

  # Tom Limoncelli's tooling for storing private information (keys, etc)
  # in a repository securely by encrypting them with gnupg
  zgenom load StackExchange/blackbox

  # A set of shell functions to make it easy to install small apps and
  # utilities distributed with pip.
  zgenom load sharat87/pip-app

  #zgenom load chrissicool/zsh-256color

  # Load more completion files for zsh from the zsh-lovers github repo
  #zgenom load zsh-users/zsh-completions src

  # Docker completion
  zgenom load srijanshetty/docker-zsh


  # Very cool plugin that generates zsh completion functions for commands
  # if they have getopt-style help text. It doesn't generate them on the fly,
  # you'll have to explicitly generate a completion, but it's still quite cool.
  zgenom load RobSis/zsh-completion-generator

  # Add Fish-like autosuggestions to your ZSH
  zgenom load zsh-users/zsh-autosuggestions

  # k is a zsh script / plugin to make directory listings more readable,
  # adding a bit of color and some git status information on files and directories
  zgenom load supercrabtree/k


  # If zsh-syntax-highlighting is bundled after zsh-history-substring-search,
  # If zsh-history-substring-search is bundled before vi-mode
  # they break, so get the order right.
  zgenom load zsh-users/zsh-syntax-highlighting
  #zgenom load zsh-users/zsh-history-substring-search

  # Set keystrokes for substring searching
  #zmodload zsh/terminfo
  #bindkey "^[OA" history-substring-search-up
  #bindkey "^[OB" history-substring-search-down

  # auto-source any .zsh_source file found in the directory
  zgenom load maximux13/zsh-auto-source-file

  # Load me last
  GENCOMPL_FPATH=$HOME/.zsh/complete

  zgenom save
fi
