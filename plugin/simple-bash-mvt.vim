" Mvt: executes commands located in .mvt file
command! -nargs=* Mvt call s:Mvt(<f-args>)

function! s:Mvt(...) abort
  if !filereadable('.mvt.vim')
    echo '.mvt not found'
    return
  endif

  if len(a:000) == 0
    call s:MvtShow()
    return
  endif

  let l:lines = readfile('.mvt.vim')

  for l:command in a:000
    for l:line in l:lines
      if l:line =~ ('^' . l:command . ': ')
        let l:commandValue = l:line[strlen(l:command . ': '): strlen(l:line)]
        echo l:commandValue
      endif
    endfor
  endfor
endfunction

:hi HiMvtShowGreen ctermfg=green cterm=bold
:hi HiMvtShowYellow ctermfg=yellow cterm=bold

" MvtShow: shows .mvt file
command! -nargs=? MvtShow call s:MvtShow()

function! s:MvtShow() abort
  if !filereadable('.mvt.vim')
    echo '.mvt not found'
    return
  endif

  let l:lines = readfile('.mvt.vim')

  echohl HiMvtShowYellow
  echo "Mvt - My vim tools commands, located in `.mvt.vim`"
  echo " "
  echohl None

  for l:line in l:lines
    if l:line !~ ('"')
      let parts = split(l:line, ':')

      echohl HiMvtShowGreen
      echo l:parts[0]
      echohl None
      echon ': ' . l:parts[1]
    endif
  endfor

  echo " "
endfunction
