:set number
:set relativenumber
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a


" Import Plugins Here
call plug#begin('~/.config/nvim/plugged')
Plug 'http://github.com/tpope/vim-surround' " Surrounding ysw)
Plug 'https://github.com/preservim/nerdtree' " NerdTree
Plug 'https://github.com/tpope/vim-commentary' " For Commenting gcc & gc
Plug 'https://github.com/vim-airline/vim-airline' " Status bar
Plug 'https://github.com/ap/vim-css-color' " CSS Color Preview
Plug 'https://github.com/rafi/awesome-vim-colorschemes' " Retro Scheme
Plug 'https://github.com/ryanoasis/vim-devicons' " Developer Icons
" Plug 'https://github.com/tc50cal/vim-terminal' " Vim Terminal

call plug#end()

" Key-Bindings
nnoremap <C-f> :NERDTreeFocus<CR>
nnoremap <C-[> :NERDTreeToggle<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-s> :w<CR>
noremap <C-d> :.t.<CR>
noremap <C-x> :del<CR>
nnoremap <C-\> :ChangeFocusToMainWindow<CR>
noremap <C-q> :q!<CR>

" colorscheme
:colorscheme elflord

" Custom Functions
command! -nargs=0 ChangeFocusToMainWindow :call ChangeFocusToMainWindow()

function! ChangeFocusToMainWindow()
    " Select the main window (first window)
    let main_window = winnr('#')
    exe main_window . 'wincmd w'
endfunction


