+
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

  let l:currentPart = 'Changes to be committed'

  for l:line in split(l:out, "\n")
    if l:currentPart == 'Changes to be committed'
      echohl HiGstGreen
    elseif if l:currentPart == 'Changes not staged for commit'
      echohl HiGstRed
    elseif if l:currentPart == 'Untracked files'
      echohl HiGstBlue
    end

    echo l:line

    if l:line == 'Changes to be committed'
      l:currentPart = 'Change to be committed'
    elseif if l:currentPart == 'Changes not staged for commit'
      l:currentPart = 'Changes not staged for commit'
    elseif if l:currentPart == 'Untracked files'
      l:currentPart = 'Untracked files'
    end
  endfor

  echo " "
endfunction

" Gbr: git branch
command! -nargs=? Gbr call s:Gbr(<f-args>)

function! s:Gbr() abort
  let l:out = system("git branch")

  echo "Gbr: git branch"
  echo " "

  for l:line in split(l:out, "\n")
    echo "  "

    if line =~ '^* '
      echohl HiGstGreen
    end

    echon l:line
    echohl None
  endfor

  echo " "
endfunction

" Gco: git checkout <branch>
command! -nargs=? Gco call s:Gco(<f-args>)

function! s:Gco(branch) abort
  echo "Gco: git checkout " . a:branch
  echo " "
  echo system("git checkout " . a:branch)
  echo " "
endfunction

" Gcb: git checkout <branch>
command! -nargs=? Gcb call s:Gcb(<f-args>)

function! s:Gcb(branch) abort
  echo "Gcb: git checkout -b " . a:branch
  echo " "
  echo system("git checkout -b " . a:branch)
  echo " "
endfunction

" Gbd: git branch -D <branch>
command! -nargs=? Gbd call s:Gbd(<f-args>)

function! s:Gbd(branch) abort
  echo "Gbd: git branch -D " . a:branch
  echo " "
  echo system("git branch -D " . a:branch)
  echo " "
endfunction

" Gdfc: git diff --cached
command! -nargs=? Gdfc call s:Gdfc(<f-args>)

function! s:Gdfc() abort
  call s:performGdf("Gdfc", " --cached")
endfunction

" Gdf: git diff
command! -nargs=? Gdf call s:Gdf(<f-args>)

function! s:Gdf() abort
  call s:performGdf("Gdf", "")
endfunction

:hi HiGdfcGreen ctermfg=green cterm=bold
:hi HiGdfcBlue ctermfg=blue cterm=bold
:hi HiGdfcRed ctermfg=red cterm=bold
:hi HiGdfcYellow ctermfg=yellow cterm=bold

function! s:performGdf(commandName, option) abort
  let l:out = system("git diff" . a:option)

  echo a:commandName . ": git diff" . a:option
  echo " "

  for line in split(l:out, "\n")
    if line =~ '^diff'
      echohl HiGdfcBlue
    elseif line =~ '^+++ ' || line =~ '^--- '
      echohl HiGdfcYellow
    elseif line =~ '^+'
      echohl HiGstGreen
    elseif line =~ '^-'
      echohl HiGstRed
    end
    echo line
    echohl None
  endfor

  echo " "
endfunction


" Ga: git add <files>
command! -nargs=? Ga call s:Ga(<f-args>)

function! s:Ga(files) abort
  echo "Ga: git add " . a:files . " --verbose"
  echo " "
  echo system("git add " . a:files . " --verbose")
  echo " "
endfunction

" Gaa: git add .
command! -nargs=? Gaa call s:Gaa(<f-args>)

function! s:Gaa() abort
  echo "Gaa: git add . --verbose"
  echo " "
  echo system("git add . --verbose")
  echo " "
endfunction

" Gr: git reset <files>
command! -nargs=? Gr call s:Gr(<f-args>)

function! s:Gr(files) abort
  echo "Gr: git reset " . a:files
  echo " "
  echo system("git reset " . a:files)
  echo " "
  call s:Gst()
endfunction

" Gra: git reset .
command! -nargs=? Gra call s:Gra(<f-args>)

function! s:Gra() abort
  echo "Gra: git reset ."
  echo " "
  echo system("git reset .")
  echo " "
  call s:Gst()
endfunction
