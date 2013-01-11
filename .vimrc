call pathogen#infect()
syntax on
filetype plugin indent on

set smarttab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set expandtab
set ruler

" GUI options
set guioptions+=T

" Color scheme
colorscheme wombat256mod

" trim trailing whitespace on any write
autocmd! BufWrite * mark ' | silent! %s/\s\+$// | norm ''

" trim whitespace at end of file on any write
autocmd BufWrite * mark ' | silent! g/^[\s\l\n]*\%$/d | norm ''

au BufReadCmd   *.svc.gz      call tar#Browse(expand("<amatch>"))
au BufReadCmd   *.gem         call tar#Browse(expand("<amatch>"))
