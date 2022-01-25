source "${HOME}/zgenom/zgenom.zsh"
if ! zgenom saved; then
  zgenom oh-my-zsh

  zgenom load unixorn/autoupdate-zgenom
  zgenom load zsh-users/zsh-syntax-highlighting
  zgenom load djui/alias-tips
  zgenom load unixorn/fzf-zsh-plugin

  zgenom oh-my-zsh plugins/git
  zgenom oh-my-zsh plugins/golang
  zgenom oh-my-zsh plugins/npm
  zgenom load chrissicool/zsh-256color
  zgenom load zsh-users/zsh-completions src
  zgenom load maximux13/zsh-auto-source-file
  zgenom load agkozak/zsh-z
  zgenom load srijanshetty/docker-zsh
  zgenom load RobSisaaizsh-completion-generator
  zgenom load zsh-users/zsh-autosuggestions
  zgenom load supercrabtree/k
  zgenom save
fi
