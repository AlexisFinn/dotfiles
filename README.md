# dotfiles
backing up my config files using https://dotfiles.github.io/
## Neovim:
`:checkhealth` to see what language servers and parsers are correctly installed and configured
### Dependencies
- NeoVim 0.5 https://github.com/neovim/neovim/releases
- fzf https://github.com/junegunn/fzf
- ripgrep https://github.com/BurntSushi/ripgrep
#### language configs
- prettier ([formatting] html, css, scss, js, ts, vue) https://prettier.io/
- php-cs-fixer ([formatting] php) https://github.com/FriendsOfPHP/PHP-CS-Fixer
- hindent ([formatting] haskell) https://hackage.haskell.org/package/hindent
- typescript-language-server ([lsp] typescript) https://github.com/theia-ide/typescript-language-server
- vetur ([lsp] vuejs) https://github.com/vuejs/vetur/tree/master/server
- yaml-unist-parser ([lsp] yaml) https://github.com/ikatyang/yaml-unist-parser
- intelephense ([lsp] php) https://www.npmjs.com/package/intelephense
- stylelint-lsp ([lsp] css/scss) https://www.npmjs.com/package/stylelint-lsp
- haskell-language-server ([lsp] haskell) https://github.com/haskell/haskell-language-server
- efm-langserver ([lsp] general purpose language server, used for prettier formatting) https://github.com/mattn/efm-langserver
- Glow (markdow previewer) https://github.com/npxbr/glow.nvim
#### extra
- vifm https://vifm.info/ integrate vifm into vim
- NerdFonts https://www.nerdfonts.com/ you should just always have nerdfonts installed
- LazyGit https://github.com/jesseduffield/lazygit definitely one of the best terminal ui for git
## Xmonad (tiling window manager) https://xmonad.org/
### Dependencies
- Xmobar (status bar) https://hackage.haskell.org/package/xmobar
- PHP (status bar scripts)
- pulseaudio-utils (for volume control)
- NerdFonts https://www.nerdfonts.com/
- rofi (launcher) https://github.com/davatorium/rofi
- alacritty (terminal) https://github.com/alacritty/alacritty
- playerctl (player control) https://github.com/altdesktop/playerctl
## Zsh
### Dependencies
- Zgen https://github.com/tarjoilija/zgen (it will install the rest)
# Extra recommended programs
- Git: lazygit https://github.com/jesseduffield/lazygit (terminal ui)
- Git: git-gui (`sudo apt-get install git-gui`)
- Web Browser: vivaldi https://vivaldi.com/
- Terminal Emulator: https://github.com/alacritty/alacritty (fast gpu-rendered terminal, awesome)
- Terminal Emulator: https://sw.kovidgoyal.net/kitty/ (fast gpu-rendered terminal, awesome, more featurefull than alacritty but if you don't use/need those extra features it's just bloated)
- Terminal: fzf https://github.com/junegunn/fzf (quickly narrow down result with a fuzzy search)
- Terminal: ripgrep https://github.com/BurntSushi/ripgrep (faster, better grep, works even better when combined with fzf)
- Terminal: z https://github.com/rupa/z (quickly jump between your most used directories, this is awesome)
- Terminal: bat https://github.com/sharkdp/bat (like `cat` but with line numbers and syntax coloring, you'll never use `cat` again)
- Terminal: tmux https://doc.ubuntu-fr.org/tmux (split a terminal into windows/tabs, if you don't use a tiling windo manager this is going to make your day)
- Remote Collaboration: tmate https://tmate.io/ (basically tmux and ssh combined in an easy way)


