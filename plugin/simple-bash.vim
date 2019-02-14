augroup Mkdir
  autocmd!
  autocmd BufWritePre *
    \ if !isdirectory(expand("<afile>:p:h")) |
    \ call mkdir(expand("<afile>:p:h"), "p") |
    \ endif
augroup END

" Rename: renames current file/buffer
command! -nargs=* Rename call s:Rename(<f-args>)

function! s:Rename(newFileName) abort
  let currentFile = resolve(expand('%:p'))
  let currentDir = resolve(expand('%:p:h'))
  let newFile = currentDir . "/" . a:newFileName

  if !isdirectory(currentDir)
    echo "current dir invalid " . currentDir
    return
  endif

  if !filereadable(currentFile)
    echo "current file unreadable " . currentFile
    return
  endif

  execute "!mv " . currentFile . " " . newFile

  bd!

  execute "e " . newFile
endfunction

" Del: deletes current file/buffer
command! -nargs=? Del call s:Del()

function! s:Del() abort
  let currentFile = resolve(expand('%:p'))

  if !filereadable(currentFile)
    echo "current file unreadable " . currentFile
    return
  endif

  execute "!rm " . currentFile

  bd!
endfunction


