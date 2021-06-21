export PATH="$HOME/go/bin:$HOME/.gem/ruby/2.7.0/bin:$HOME/.config/composer/vendor/bin:$HOME/bin:$HOME/.local/bin:$HOME/.cabal/bin:$PATH"
export SPICETIFY_INSTALL="/home/alexis/spicetify-cli"
export PATH="$SPICETIFY_INSTALL:$PATH"
export FZF_DEFAULT_COMMAND='ag -al'

# pymal custom colors
#(cat ~/.cache/wal/sequences &)
# wpgtk with haishoku backend
(cat ~/.config/wpg/templates/sequences &)

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source "${HOME}/.zgen-setup"

# Set Zsh option
setopt correct

for file in $HOME/.zshrc.d/*; do
    source "$file"
done


function chpwd() {
    if [ -e $PWD/bash_aliases.sh ]; then
        source $PWD/bash_aliases.sh
    else
        unalias -m 'bb-*'
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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source /home/alexis/.config/broot/launcher/bash/br

eval "$(starship init zsh)"

