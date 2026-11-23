# ~/.zshrc — standalone config, no framework or plugin manager.
# Profile startup: uncomment the next line, and add `zprof` at the end of the file.
#zmodload zsh/zprof

# Terminal colours from wpgtk; $(<file) reads the file without forking.
[[ -r ~/.cache/wpg/sequences ]] && print -rn -- "$(<~/.cache/wpg/sequences)"

ZSH_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
ZSH_PLUGINS="${ZSH_PLUGINS:-${XDG_DATA_HOME:-$HOME/.local/share}/zsh}"
[[ -d $ZSH_CACHE ]] || mkdir -p $ZSH_CACHE

# Sources the first readable file among the arguments.
_zsrc() {
  local f
  for f; do [[ -r $f ]] && { source $f; return 0 }; done
  return 1
}

# Sources the output of a command, cached until the command's binary changes.
_zsrc_cached() {
  local name=$1; shift
  local bin=${commands[$1]} cache=$ZSH_CACHE/$name.zsh
  [[ -n $bin ]] || return 1
  [[ -s $cache && $cache -nt $bin ]] || "$@" >| $cache
  source $cache
}

# ---------------------------------------------------------------- environment
export EDITOR=nvim
export PAGER=less LESS=-R
export GOPATH="$HOME/go"
export NVIMPATH="$HOME/nvim"
export GEMPATH="$HOME/.local/share/gem/ruby/3.0.0"
export CARGOPATH="$HOME/.cargo/"
export DENOPATH="$HOME/.deno"
export BUN_INSTALL="$HOME/.bun"
export NVM_DIR="$HOME/.nvm"
export LUA_PATH="/usr/share/lua/5.4/?.lua;"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'

export PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:$PERL5LIB}"
export PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:$PERL_LOCAL_LIB_ROOT}"
export PERL_MB_OPT="--install_base \"$HOME/perl5\""
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"

typeset -U path
path=(
  $BUN_INSTALL/bin
  $HOME/perl5/bin
  $DENOPATH/bin $NVIMPATH/bin $GEMPATH/bin $GOPATH/bin $CARGOPATH/bin
  $HOME/.config/composer/vendor/bin
  $HOME/bin $HOME/.local/bin $HOME/.cabal/bin
  $path
)
[[ -r ~/.ghcup/env ]] && source ~/.ghcup/env

# nvm is slow to source, so the default Node goes on PATH directly and nvm.sh
# loads on the first `nvm` call. The default alias is a version prefix ("24");
# for anything else (lts/*, node) the newest installed version is used.
() {
  local ver dirs
  [[ -r $NVM_DIR/alias/default ]] && ver=$(<$NVM_DIR/alias/default)
  dirs=( $NVM_DIR/versions/node/v${ver#v}(|.*)(N/n) )
  (( $#dirs )) || dirs=( $NVM_DIR/versions/node/v*(N/n) )
  (( $#dirs )) && path=( $dirs[-1]/bin $path )
}
nvm() {
  unfunction nvm
  source $NVM_DIR/nvm.sh
  if [[ -r $NVM_DIR/bash_completion ]]; then
    autoload -Uz bashcompinit && bashcompinit
    source $NVM_DIR/bash_completion
  fi
  nvm "$@"
}

# -------------------------------------------------------------------- options
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=10000
setopt extended_history hist_expire_dups_first hist_ignore_dups \
       hist_ignore_space hist_verify share_history
setopt auto_cd auto_pushd pushd_ignore_dups pushd_minus
setopt interactive_comments long_list_jobs multios
setopt complete_in_word always_to_end auto_menu
unsetopt menu_complete flow_control

# ----------------------------------------------------------------- completion
fpath=($ZSH_PLUGINS/completions(N/) $fpath)
zmodload -i zsh/complist
autoload -Uz compinit
# The dump is checked for new completion functions once a day; other starts
# trust it (-C). Its name is fixed: a hostname in it would force a rebuild
# whenever DHCP hands out a new hostname.
() {
  local dump=$ZSH_CACHE/zcompdump
  local -a fresh=( $dump(N.mh-24) )
  if (( $#fresh )); then
    compinit -C -d $dump
  else
    compinit -d $dump && touch $dump
  fi
  [[ $dump.zwc -nt $dump ]] || zcompile -R $dump &!
}
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path $ZSH_CACHE/compcache
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,user,comm -w -w"
[[ -s $BUN_INSTALL/_bun ]] && source $BUN_INSTALL/_bun

# --------------------------------------------------------------- key bindings
bindkey -v
autoload -Uz edit-command-line up-line-or-beginning-search down-line-or-beginning-search
autoload -Uz url-quote-magic bracketed-paste-magic
zle -N edit-command-line
zle -N self-insert url-quote-magic
zle -N bracketed-paste bracketed-paste-magic

bindkey -M vicmd 'vv' edit-command-line
bindkey '^X^E' edit-command-line
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char
bindkey '^W' backward-kill-word
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey ' ' magic-space
bindkey -M menuselect '^O' accept-and-infer-next-history
bindkey '^[[Z' reverse-menu-complete

# Up/Down search history for lines starting with what is already typed.
bindkey '^[[A' history-search-backward '^[OA' history-search-backward
bindkey '^[[B' history-search-forward  '^[OB' history-search-forward

() {
  local m
  for m in viins vicmd; do
    bindkey -M $m '^[[H' beginning-of-line '^[OH' beginning-of-line '^[[1~' beginning-of-line
    bindkey -M $m '^[[F' end-of-line '^[OF' end-of-line '^[[4~' end-of-line
    bindkey -M $m '^[[3~' delete-char
    bindkey -M $m '^[[1;5C' forward-word '^[[1;5D' backward-word
  done
}

# Clipboard, shared with vi yank/put below.
if [[ -n $WAYLAND_DISPLAY ]]; then
  clipcopy()  { wl-copy < "${1:-/dev/stdin}" }
  clippaste() { wl-paste --no-newline }
else
  clipcopy()  { xclip -selection clipboard -in < "${1:-/dev/stdin}" }
  clippaste() { xclip -selection clipboard -out }
fi

# Vi yank/change/delete also copy to the system clipboard; vi put pastes from it.
() {
  local w
  for w in vi-yank vi-yank-eol vi-yank-whole-line vi-change vi-change-eol \
           vi-change-whole-line vi-kill-line vi-kill-eol vi-backward-kill-word \
           vi-delete vi-delete-char vi-backward-delete-char; do
    eval "_clip-$w() { zle .$w; print -rn -- \"\$CUTBUFFER\" | clipcopy 2>/dev/null }"
    zle -N $w _clip-$w
  done
  for w in vi-put-before vi-put-after put-replace-selection; do
    eval "_clip-$w() { CUTBUFFER=\"\$(clippaste 2>/dev/null || print -rn -- \"\$CUTBUFFER\")\"; zle .$w }"
    zle -N $w _clip-$w
  done
}

# Esc Esc toggles a `sudo ` prefix (on the previous command if the line is empty).
sudo-command-line() {
  [[ -z $BUFFER ]] && LBUFFER="$(fc -ln -1)"
  if [[ $BUFFER == sudo\ * ]]; then
    LBUFFER="${LBUFFER#sudo }"
  else
    LBUFFER="sudo $LBUFFER"
  fi
}
zle -N sudo-command-line
bindkey -M viins '\e\e' sudo-command-line
bindkey -M vicmd '\e\e' sudo-command-line

# ---------------------------------------------------------------------- hooks
autoload -Uz add-zsh-hook

# Window title: "user@host: dir" at the prompt, the command while it runs.
_title_precmd()  { print -Pn '\e]2;%n@%m: %~\a' }
_title_preexec() { print -rn -- $'\e]2;'"${1//[[:cntrl:]]/}"$'\a' }
add-zsh-hook precmd _title_precmd
add-zsh-hook preexec _title_preexec

# Reports the cwd to the terminal (OSC 7) so new windows open in the same place.
if [[ -z $SSH_TTY && $TERM == (foot*|xterm*|alacritty*|tmux*|screen*|kitty*) ]]; then
  _osc7_cwd() { print -rn -- $'\e]7;file://'"$HOST${${PWD//\%/%25}// /%20}"$'\e\\' }
  add-zsh-hook precmd _osc7_cwd
fi

# Sources per-directory shell files when entering a directory.
# Any directory can carry them, including cloned repositories.
_local_shell_files() {
  local f
  for f in bash_aliases.sh bash-aliases.sh .zsh_source; do
    [[ -f $f && -r $f ]] && source ./$f
  done
}
add-zsh-hook chpwd _local_shell_files

# -------------------------------------------------------------------- aliases
alias history='fc -l 1'
alias -- -='cd -'
alias ...='../..' ....='../../..' .....='../../../..'
alias md='mkdir -p' rd=rmdir d='dirs -v | head -n 10'
alias rm='rm -i' cp='cp -i' mv='mv -i'
alias pip='noglob pip' pipi='pip install'

# git
alias g=git ga='git add' gaa='git add --all'
alias gb='git branch' gc='git commit --verbose' 'gc!'='git commit --verbose --amend'
alias gco='git checkout' gcb='git checkout -b' gd='git diff'
alias gf='git fetch' gfa='git fetch --all --tags --prune --jobs=10'
alias gl='git pull' gp='git push' gpf='git push --force'
alias glgp='git log --stat --patch' glog='git log --oneline --decorate --graph'
alias grb='git rebase' grbi='git rebase --interactive' grba='git rebase --abort' grbc='git rebase --continue'
alias gst='git status' gsta='git stash push' gstp='git stash pop' gstl='git stash list' gsts='git stash show --patch'

# docker / systemd
alias dps='docker ps'
alias dcup='docker-compose up' dcb='docker-compose build' dcps='docker-compose ps'
alias dcdn='docker-compose down' dcl='docker-compose logs' dclf='docker-compose logs -f'
alias dup='docker-compose up -d' ddown='docker-compose down'
() {
  local c
  for c in status show list-units is-active cat; do alias sc-$c="systemctl $c"; done
  for c in start stop restart reload enable disable; do alias sc-$c="sudo systemctl $c"; done
}

# personal
alias c=clear b=fg cdc='cd && clear'
alias C=qalc calculator=qalculate
alias tig='tig status'
alias weather='curl -H "Accept-Language: fr" wttr.in/Montauban'
alias vi=nvim vim=nvim
alias sudo='sudo -EH'
alias net=nmtui
alias searchfor='grep -rnw . -e'
alias lognav=lnav top=btop cat=bat cam=qv4l2
alias ls=eza ll='eza -alh'
alias gitprune="git branch -vv | grep ': disparue]' | grep -v \"\\*\" | awk '{ print \$1; }' | xargs -r git branch -D"
alias t=todo.sh tadd='todo.sh add' tl='todo.sh ls' trm='todo.sh rm' tdo='todo.sh do'
alias clock='tty-clock -c'
alias grep=rg
alias lg=lazygit ld=lazydocker
alias logout='dm-tool switch-to-greeter'
alias em='emacsclient -c &'
alias nv="neovide --neovim-bin $HOME/nvim/bin/nvim"
alias luamake=$HOME/Applications/lua-language-server/3rd/luamake/luamake

# ------------------------------------------------------------------ functions
# Coloured man pages.
man() {
  LESS_TERMCAP_mb=$'\e[01;31m' LESS_TERMCAP_md=$'\e[01;31m' LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[01;33;44m' LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[01;32m' LESS_TERMCAP_ue=$'\e[0m' \
  GROFF_NO_SGR=1 PAGER=less command man "$@"
}

# nnn, changing directory on quit.
fm() {
  if (( ${NNNLVL:-0} >= 1 )); then
    echo "nnn is already running"
    return
  fi
  export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
  nnn "$@"
  if [[ -f $NNN_TMPFILE ]]; then
    source $NNN_TMPFILE
    command rm -f $NNN_TMPFILE
  fi
}

(( $+commands[broot] )) && _zsrc ~/.config/broot/launcher/bash/br

# --------------------------------------------------------------------- prompt
# Left:  directory, git (branch, * when dirty, ⇣⇡ when behind/ahead), ❯
#        (❮ in vi command mode; red after a failed command).
# Right: duration of the last command when ≥ 5 s, virtualenv, user@host over
#        SSH or as root, time.
# Git status runs in a background process; the prompt is redrawn when it
# returns, so a slow repository never delays the prompt.
# PROMPT is rebuilt as a literal string (prompt_subst stays off), so a branch
# name is never evaluated by the shell.
zmodload zsh/datetime
autoload -Uz add-zle-hook-widget
export VIRTUAL_ENV_DISABLE_PROMPT=1

typeset -g _p_status=0 _p_start= _p_duration= _p_vicmd=0
typeset -g _p_git= _p_git_dir= _p_git_fd=0

_p_render() {
  local char='❯' color=5
  (( _p_vicmd )) && char='❮'
  (( _p_status )) && color=1
  PROMPT="%F{4}%~%f${_p_git:+ $_p_git} %F{$color}$char%f "

  local -a right
  [[ -n $_p_duration ]] && right+="%F{3}$_p_duration%f"
  [[ -n $VIRTUAL_ENV ]] && right+="%F{242}${${VIRTUAL_ENV:t}//\%/%%}%f"
  if (( EUID == 0 )); then
    right+="%F{7}%n%f%F{242}@%m%f"
  elif [[ -n $SSH_CONNECTION ]]; then
    right+="%F{242}%n@%m%f"
  fi
  right+="%F{242}%D{%H:%M:%S}%f"
  RPROMPT=${(j: :)right}
}

# Prints the git segment for the current directory, or nothing outside a repo.
_p_git_info() {
  local out line branch oid dirty ahead=0 behind=0 s
  out=$(command git status --porcelain=v2 --branch 2>/dev/null) || return
  for line in ${(f)out}; do
    case $line in
      ('# branch.head '*) branch=${line#\# branch.head } ;;
      ('# branch.oid '*)  oid=${line#\# branch.oid } ;;
      ('# branch.ab '*)   ahead=${${=line}[3]#+}; behind=${${=line}[4]#-} ;;
      ('#'*) ;;
      (*) dirty='*' ;;
    esac
  done
  [[ $branch == '(detached)' ]] && branch="@${oid[1,8]}"
  s="%F{242}${branch//\%/%%}$dirty%f"
  if (( ahead || behind )); then
    s+=" %F{6}"
    (( behind )) && s+='⇣'
    (( ahead )) && s+='⇡'
    s+='%f'
  fi
  print -rn -- $s
}

_p_git_start() {
  if (( _p_git_fd )); then
    zle -F $_p_git_fd 2>/dev/null
    exec {_p_git_fd}<&-
    _p_git_fd=0
  fi
  exec {_p_git_fd}< <(_p_git_info)
  zle -F $_p_git_fd _p_git_done
}

_p_git_done() {
  local fd=$1 out
  IFS= read -r -u $fd out
  zle -F $fd
  exec {fd}<&-
  _p_git_fd=0
  if [[ $out != $_p_git ]]; then
    _p_git=$out
    _p_render
    zle && zle reset-prompt
  fi
}

_p_preexec() { _p_start=$EPOCHREALTIME }

_p_precmd() {
  _p_status=$?
  _p_duration=
  if [[ -n $_p_start ]]; then
    local -i t=$(( EPOCHREALTIME - _p_start ))
    _p_start=
    if (( t >= 5 )); then
      local d=$((t / 86400)) h=$((t % 86400 / 3600)) m=$((t % 3600 / 60)) s=$((t % 60))
      (( d )) && _p_duration+="${d}d "
      (( d || h )) && _p_duration+="${h}h "
      (( d || h || m )) && _p_duration+="${m}m "
      _p_duration+="${s}s"
    fi
  fi
  _p_vicmd=0
  # The previous git segment stays on screen until the new one arrives,
  # unless the directory changed.
  [[ $PWD == $_p_git_dir ]] || _p_git=
  _p_git_dir=$PWD
  _p_render
  _p_git_start
}

_p_keymap_select() {
  local vicmd=0
  [[ $KEYMAP == vicmd ]] && vicmd=1
  (( vicmd == _p_vicmd )) && return
  _p_vicmd=$vicmd
  _p_render
  zle reset-prompt
}

_p_line_finish() {
  (( _p_vicmd )) || return
  _p_vicmd=0
  _p_render
  zle reset-prompt
}

add-zsh-hook preexec _p_preexec
add-zsh-hook precmd _p_precmd
add-zle-hook-widget keymap-select _p_keymap_select
add-zle-hook-widget line-finish _p_line_finish

# -------------------------------------------------------------------- plugins
_zsrc_cached fzf fzf --zsh

ZSH_AUTOSUGGEST_STRATEGY=(history)
_zsrc /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
      $ZSH_PLUGINS/zsh-autosuggestions/zsh-autosuggestions.zsh

# Must come after every other widget definition.
_zsrc /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
      $ZSH_PLUGINS/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

_zsrc_cached zoxide zoxide init zsh --cmd z

unfunction _zsrc _zsrc_cached

# >>> zest-agents setup
alias claude-epic='CLAUDE_AUTOCOMPACT_PCT_OVERRIDE=50 CLAUDE_CODE_PROMPT_CACHE_TTL=1h claude'
# <<< zest-agents setup
