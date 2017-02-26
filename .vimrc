" We don't want to be compatible to vi.
set nocompatible

" Load pathogen.
runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()

source ~/.vim/jk-not-esc.vim
source ~/.vim/no-arrow-keys.vim
