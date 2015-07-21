execute pathogen#infect()
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

au BufReadCmd   *.sonas.gz    call tar#Browse(expand("<amatch>"))
au BufReadCmd   *.xiv.gz      call tar#Browse(expand("<amatch>"))
au BufReadCmd   *.svc.gz      call tar#Browse(expand("<amatch>"))
au BufReadCmd   *.ds.gz       call tar#Browse(expand("<amatch>"))
au BufReadCmd   *.vmware.gz   call tar#Browse(expand("<amatch>"))
au BufReadCmd   *.netapp7mode.gz   call tar#Browse(expand("<amatch>"))
au BufReadCmd   *.ibmi.Z      call tar#Browse(expand("<amatch>"))
au BufReadCmd   *.gem         call tar#Browse(expand("<amatch>"))

" Omni completion (autocomplete) options
set completeopt=longest,menuone
inoremap <tab> <c-r>=Smart_TabComplete()<CR>

" Smart tab-key mapping; insert tab at beginning of line, trigger autocomplete
" elsewehere
function! Smart_TabComplete()
  let line = getline('.')                         " current line

  let substr = strpart(line, -1, col('.')+1)      " from the start of the current
                                                  " line to one character right
                                                  " of the cursor
  let substr = matchstr(substr, "[^ \t]*$")       " word till cursor
  if (strlen(substr)==0)                          " nothing to match on empty string
    return "\<tab>"
  endif
  let has_period = match(substr, '\.') != -1      " position of period, if any
  let has_slash = match(substr, '\/') != -1       " position of slash, if any
  if (!has_period && !has_slash)
    return "\<C-X>\<C-P>"                         " existing text matching
  elseif ( has_slash )
    return "\<C-X>\<C-F>"                         " file matching
  else
    return "\<C-X>\<C-O>"                         " plugin matching
  endif
endfunction
