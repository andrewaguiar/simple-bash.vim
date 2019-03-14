" creates dir when trying to save a buffer inside a absent dir
augroup Mkdir
  autocmd!
  autocmd BufWritePre *
    \ if !isdirectory(expand("<afile>:p:h")) |
    \ call mkdir(expand("<afile>:p:h"), "p") |
    \ endif
augroup END

" Move: moves current file a new directory
command! -nargs=* Move call s:Move(<f-args>)

function! s:Move(newDir) abort
  let currentFile = resolve(expand('%:p'))
  let currentFileName = resolve(expand('%:t'))
  let currentDir = resolve(expand('%:p:h'))
  let newFile = a:newDir . "/" . currentFileName

  if !filereadable(currentFile)
    echo "current file unreadable " . currentFile
    return
  endif

  if !isdirectory(a:newDir)
    execute "!mkdir -p " . a:newDir
  endif

  execute "!mv " . currentFile . " " . newFile

  bd!

  execute "e " . newFile
endfunction

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

" New: creates a new file in same dir of current file / buffer.
command! -nargs=* New call s:New(<f-args>)

function! s:New(newFileName) abort
  let currentDir = resolve(expand('%:p:h'))
  let newFile = currentDir . "/" . a:newFileName

  execute "!touch " . newFile

  bd!

  execute "e " . newFile
endfunction

" Copy: copies current file/buffer to another file
command! -nargs=* Copy call s:Copy(<f-args>)

function! s:Copy(newFileName) abort
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

  execute "!cp " . currentFile . " " . newFile

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

" Remove: deletes dir/file.
command! -nargs=* Remove call s:Remove(<f-args>)

function! s:Remove(dirOrFilename) abort
  execute "!rm -fr " . a:dirOrFilename
endfunction

" Mkdirs: creates mutiples dirs
command! -nargs=+ Mkdirs call s:Mkdirs(<f-args>)

function! s:Mkdirs(...) abort
  for dir in a:000
    execute "!mkdir -p " . dir
  endfor
endfunction
