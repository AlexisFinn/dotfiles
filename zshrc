# zmodload zsh/zprof

export GOPATH="$HOME/go"
export NVIMPATH="$HOME/nvim"
export GHCUPPATH="$HOME/.ghcup"
export GEMPATH="$HOME/.local/share/gem/ruby/3.0.0"
export PATH="$NVIMPATH/bin:$GEMPATH/bin:$GHCUPPATH/bin:$GOPATH/bin:$HOME/.config/composer/vendor/bin:$HOME/bin:$HOME/.local/bin:$HOME/.cabal/bin:$PATH"
export SPICETIFY_INSTALL="/home/alexis/spicetify-cli"
export PATH="$SPICETIFY_INSTALL:$PATH"
export FZF_DEFAULT_COMMAND='ag -al'
export EDITOR="nvim"

# pymal custom colors
#(cat ~/.cache/wal/sequences &)
# wpgtk with haishoku backend
if [[ -f ~/.cache/wpg/sequences ]]; then
  (cat ~/.cache/wpg/sequences &)
fi

source "/usr/share/nvm/init-nvm.sh"

source "${HOME}/zsh-setup.zsh"


# Set Zsh option
#setopt correct

for file in $HOME/.zshrc.d/*; do
    source "$file"
done

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

function chpwd() {
    if [ -e $PWD/bash_aliases.sh ]; then
        source $PWD/bash_aliases.sh
    fi
}


# perl cpan config
PATH="/home/alexis/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/alexis/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/alexis/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/alexis/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/alexis/perl5"; export PERL_MM_OPT;

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#linuxlogo -w 120
#for i in {0..255}; do
#    printf "\x1b[38;5;${i}mcolor%-5i\x1b[0m" $i ;
#    if ! (( ($i + 1 ) % 12 )); then
#        echo ;
#    fi ;
#done
source /home/alexis/.config/broot/launcher/bash/br
alias luamake=/home/alexis/Applications/lua-language-server/3rd/luamake/luamake

#[ -f "/home/alexis/.ghcup/env" ] && source "/home/alexis/.ghcup/env" # ghcup-env

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#eval "$(starship init zsh)"

#fortune -s | lolcat

# zprof

[ -f "/home/alexis/.ghcup/env" ] && source "/home/alexis/.ghcup/env" # ghcup-env
# bun completions
[ -s "/home/alexis/.bun/_bun" ] && source "/home/alexis/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

