" https://github.com/oshevtsov/vim-gherkin-formatter
" Only do this when not done yet for this buffer
if exists("b:did_ft_cucumber_formatter")
  finish
endif
let b:did_ft_cucumber_formatter = 1

" Gherkin formatter
function s:DoFormatGherkin()
  let l:cur_buffer = bufnr('%')
  if getbufvar(l:cur_buffer, "&mod")
    let l:do_save = confirm("Must save the buffer first.", "&yes\n&no", 1)
    if l:do_save == 1
      write
    else
      return
    endif
  endif
  execute "!vim-gherkin-formatter %" | edit
endfunction

augroup GHERKIN
  " remove all existing listeners in this group before reattaching them
  autocmd!

  " Define commands and mappings local to the Gherkin files
  autocmd BufEnter *.feature command! GherkinFormat :silent call s:DoFormatGherkin()
  autocmd BufLeave *.feature delcommand GherkinFormat

  autocmd BufEnter *.feature nnoremap <buffer> <F4> :GherkinFormat<cr>

  " autocmd BufWritePost *.feature :GherkinFormat<cr>
augroup END
