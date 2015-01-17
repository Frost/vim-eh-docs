au BufNewFile,BufRead {*.ex,*.exs} set filetype=elixir

if exists('g:ehdocs_lookup_command')
  au FileType elixir setlocal keywordprg=&g:ehdocs_lookup_command
endif
