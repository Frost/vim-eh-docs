" Vim global plugin for accessing elixir documentation using `mix eh` (or
" compatible)
" Last Change:  2015-01-16
" Maintainer:   Martin Frost <frost@ceri.se>
" License:      This file is placed in the public domain.

let s:keepcpo = &cpo
set cpo&vim

if !exists('g:ehdocs_map_keys')
  let g:ehdocs_map_keys = 1
endif

if !exists('g:ehdocs_map_prefix')
  let g:ehdocs_map_prefix = '<leader>'
endif

if !exists('g:ehdocs_lookup_command')
  let g:ehdocs_lookup_command = 'mix eh'
endif

function! s:GetCurrentChar()
  return matchstr(getline('.'), '\%' . col('.') . 'c.')
endfunction

function! s:SelectKeyword()
  " when cursor at one of:
  "
  "     Foo.Bar.baz<(>)
  "     Foo<.>Bar.baz()
  "     Foo.Bar<.>baz()
  "     Foo.Bar.baz< >some, args
  "
  " jump back one word
  if matchstr(s:GetCurrentChar(), "[(. ]")
    normal! b
  endif

  " jump to end of current word
  normal! e

  " when cursor at one of:
  "
  "     <(>Foo.Bar.baz())
  "     Foo.Bar.z<(>)
  "     F<.>Bar.baz()
  "     Foo.B<.>baz()
  "     Foo.Bar.z< >some, args
  "
  " step back one character
  if matchstr(s:GetCurrentChar(), "[(. ]")
    normal! h
  endif

  " select back to beginning of WORD
  normal! vB

  " when cursor at:
  "
  "     <(>Foo.Bar.baz())
  "
  " jump one step forward
  if s:GetCurrentChar() == '('
    " normal! 2lb
    normal! l
  endif

  " yank the selected keyword
  "
  " This should be one of (based on above examples):
  "
  "     Foo
  "     Foo.Bar
  "     Foo.Bar.baz
  "     Foo.Bar.z
  "     F.Bar.baz
  "     Foo.B.baz
  normal! y

  return @"
endfunction

" Look up an Elixir keyword using the currently set keywordprg
"
" 1. save cursor position
" 2. look up keyword
" 3. restore cursor position
function! s:EhDocsLookup()
  let cursor_position = getpos('.')
  let keyword = s:SelectKeyword()
  execute '!' . g:ehdocs_lookup_command . ' ' . keyword
  call setpos('.', cursor_position)
endfunction

command! EhDocsLookup :call <sid>EhDocsLookup()
execute "nnoremap " . g:ehdocs_map_prefix . 'k' . " :EhDocsLookup<cr>"

