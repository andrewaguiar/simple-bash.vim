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

" Mkdirs: creates mutiples dirs
command! -nargs=+ Mkdirs call s:Mkdirs(<f-args>)

function! s:Mkdirs(...) abort
  for dir in a:000
    execute "!mkdir -p " . dir
  endfor
endfunction

" GIT

" Gst: git status --porcelain
:hi HiGstGreen ctermfg=green cterm=bold
:hi HiGstBlue ctermfg=blue cterm=bold
:hi HiGstRed ctermfg=red cterm=bold
:hi HiGstYellow ctermfg=yellow cterm=bold

command! -nargs=? Gst call s:Gst(<f-args>)

function! s:Gst() abort
  let l:out = system("git status --porcelain")

  echo "Gst: git status --porcelain"
  echo " "

  for line in split(l:out, "\n")
    let l:parts = split(line, " ")
    let l:status = l:parts[0]
    let l:file = l:parts[-1]

    echo "  "

    if l:status == 'M'
      echohl HiGstGreen
    elseif l:status == 'D'
      echohl HiGstRed
    elseif l:status == 'A'
      echohl HiGstBlue
    else
      echohl HiGstYellow
    end

    echon l:status
    echohl None
    echon " " . l:file
  endfor

  echo " "

  echohl HiGstGreen
  echo "M"
  echohl None
  echon "odified, "
  echohl HiGstBlue
  echon "A"
  echohl None
  echon "dded, "
  echohl HiGstRed
  echon "D"
  echohl None
  echon "eleted, "
  echohl HiGstYellow
  echon "??"
  echohl None
  echon "-Untracked"
endfunction

" Gco: git checkout <branch>
command! -nargs=? Gco call s:Gco(<f-args>)

function! s:Gco(branch) abort
  let l:out = system("git checkout " . a:branch)

  echon "Changed to branch "
  echohl HiGstGreen
  echon a:branch
  echohl None
endfunction

" Gcb: git checkout <branch>
command! -nargs=? Gcb call s:Gcb(<f-args>)

function! s:Gcb(branch) abort
  let l:out = system("git checkout -b " . a:branch)

  echon "New branch created "
  echohl HiGstGreen
  echon a:branch
  echohl None
endfunction
