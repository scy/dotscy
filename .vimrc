" Really really basic stuff: Ignore vi compatibility, use filetype plugins and
" syntax highlighting.
set nocompatible
filetype plugin on
syntax on

" Special settings for Windows.
if has('win32') || has('win16')
	source ~/.vim/windows.vim
endif

" Load pathogen.
runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()

source ~/.vim/display.vim
source ~/.vim/jk-not-esc.vim
source ~/.vim/no-arrow-keys.vim
source ~/.vim/vimwiki-config.vim
