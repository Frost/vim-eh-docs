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
  "     <(>Foo.Bar.baz())
  "     Foo.Bar.z<(>)
  "     F<.>Bar.baz()
  "     Foo.B<.>baz()
  "     Foo.Bar.z< >some, args
  "
  " step back one character
  if match(s:GetCurrentChar(), "[\\[{(,.]") == 0
    normal! h
  elseif match(s:GetCurrentChar(), "[)}\\]]") == 0
    normal! %h
  else
    normal! e
  endif

  " Do a little hack where we temporarily add '.' to the list of
  " characters allowed in keywords, te be able to select everything from
  " the current position, and to the beginning of the word (which now
  " includes module separators ('.')).
  setlocal iskeyword+=.
  normal! vb
  normal! y
  setlocal iskeyword-=.

  " Remove any pending punctuation characters: ,.{([
  return substitute(@", "[,.{(\\[]*$", "", "")
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
command! Eh :call <sid>EhDocsLookup()
execute "nnoremap " . g:ehdocs_map_prefix . 'k' . " :Eh<cr>"
if g:ehdocs_map_keys
  execute "nnoremap K Eh<cr>"
endif

