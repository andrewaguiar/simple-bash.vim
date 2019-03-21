" Ghelp
command! -nargs=? Ghelp call s:Ghelp(<f-args>)

function! s:Ghelp() abort
  echo " "
  echo "- Ghelp: shows this list of Git commands"
  echo "- Gbr: performs a `git branch` and shows the result."
  echo "- Gst: performs a `git status --porcelain` and shows the result."
  echo "- Gco <branch>: performs a `git checkout <branch>`."
  echo "- Gcb <new-branch>: performs a `git checkout -b <new-branch>`."
  echo "- Gbd <branch>: performs a `git branch -D <branch>`."
  echo "- Gdf: performs a `git diff` and shows the result."
  echo "- Gdfc: performs a `git diff --cached` and shows the result."
  echo "- Ga <files>: performs a `git add <files> --verbose`."
  echo "- Gaa: performs a `git add . --verbose`."
  echo "- Gr <files>: performs a `git reset <files>`."
  echo "- Gra: performs a `git reset .`."
  echo "- Gcn <files>: performs a `git clean -f <files>`."
  echo "- Gcna: performs a `git clean -f .`."
  echo "- Gpl: performs a `git pull`."
  echo "- Gft: performs a `git fetch origin`."
  echo "- Gps: performs a `git push origin \$(git rev-parse --abbrev-ref HEAD)`."
  echo "- Gpsf: performs a `git push origin \$(git rev-parse --abbrev-ref HEAD) --force`."
  echo "- Gci <message>: performs a `git commit -m \"<message>\"`."
  echo "- Gcia: performs a `git commit -C HEAD --ammend`."
  echo " "
endfunction

" Gst: git status --porcelain
:hi HiGstGreen ctermfg=green cterm=bold
:hi HiGstBlue ctermfg=blue cterm=bold
:hi HiGstRed ctermfg=red cterm=bold
:hi HiGstYellow ctermfg=yellow cterm=bold

command! -nargs=? Gst call s:Gst(<f-args>)

function! s:Gst() abort
  let l:out = system("git status")

  echo "Gst: git status"
  echo " "

  let l:currentPart = ''

  for l:line in split(l:out, "\n")
    if l:line == 'Changes to be committed:'
      let l:currentPart = 'c'
    elseif l:line == 'Changes not staged for commit:'
      let l:currentPart = 'n'
    elseif l:line == 'Untracked files:'
      let l:currentPart = 'u'
    end

    if match(l:line, "\t") == 0
      if l:currentPart == 'c'
        echohl HiGstGreen
      elseif l:currentPart == 'n'
        echohl HiGstRed
      elseif l:currentPart == 'u'
        echohl HiGstBlue
      end

      echo l:line

      echohl None
    elseif l:line == ""
      echo " "
    elseif l:line !~ "  ("
      echo l:line
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

  for l:line in split(l:out, "\n")
    if l:line =~ '^diff'
      echohl HiGdfcBlue
    elseif l:line =~ '^+++ ' || l:line =~ '^--- '
      echohl HiGdfcYellow
    elseif l:line =~ '^+'
      echohl HiGstGreen
    elseif l:line =~ '^-'
      echohl HiGstRed
    end
    echo l:line
    echohl None
  endfor

  echo " "
endfunction

function! s:performSimpleGitCommand(header, command) abort
  echo a:header . ": " . a:command
  echo " "
  echo system(a:command)
  echo " "
endfunction

function! s:performSimpleGitCommandWithGst(header, command) abort
  call s:performSimpleGitCommand(a:header, a:command)
  call s:Gst()
endfunction

" Ga: git add <files>
command! -nargs=? Ga call s:Ga(<f-args>)

function! s:Ga(files) abort
  let l:h = "Ga"
  let l:c = "git add " . a:files . " --verbose"

  call s:performSimpleGitCommand(l:h, l:c)
endfunction

" Gaa: git add .
command! -nargs=? Gaa call s:Gaa(<f-args>)

function! s:Gaa() abort
  let l:h = "Gaa"
  let l:c = "git add . --verbose"

  call s:performSimpleGitCommand(l:h, l:c)
endfunction

" Gr: git reset <files>
command! -nargs=? Gr call s:Gr(<f-args>)

function! s:Gr(files) abort
  let l:h = "Gr"
  let l:c = "git reset " . a:files

  call s:performSimpleGitCommandWithGst(l:h, l:c)
endfunction

" Gra: git reset .
command! -nargs=? Gra call s:Gra(<f-args>)

function! s:Gra() abort
  let l:h = "Gra"
  let l:c = "git reset ."

  call s:performSimpleGitCommandWithGst(l:h, l:c)
endfunction

" Gcn: git clean -f <files>
command! -nargs=? Gcn call s:Gcn(<f-args>)

function! s:Gcn(files) abort
  let l:h = "Gcn"
  let l:c = "git clean -f " . a:files

  call s:performSimpleGitCommandWithGst(l:h, l:c)
endfunction

" Gcna: git clean -f .
command! -nargs=? Gcna call s:Gcna(<f-args>)

function! s:Gcna() abort
  let l:h = "Gra"
  let l:c = "git clean -f ."

  call s:performSimpleGitCommandWithGst(l:h, l:c)
endfunction

" Gpl: git pull
command! -nargs=? Gpl call s:Gpl()

function! s:Gpl() abort
  let l:h = "Gpl"
  let l:c = "git pull"

  call s:performSimpleGitCommand(l:h, l:c)
endfunction

" Gft: git fetch origin
command! -nargs=? Gft call s:Gft()

function! s:Gft() abort
  let l:h = "Gft"
  let l:c = "git fetch origin"

  call s:performSimpleGitCommand(l:h, l:c)
endfunction

" Gps: git push origin \$(git rev-parse --abbrev-ref HEAD)
command! -nargs=? Gps call s:Gps()

function! s:Gps() abort
  let l:h = "Gps"
  let l:c = "git push origin \$(git rev-parse --abbrev-ref HEAD)"

  call s:performSimpleGitCommand(l:h, l:c)
endfunction

" Gpsf: git push origin \$(git rev-parse --abbrev-ref HEAD) --force
command! -nargs=? Gpsf call s:Gpsf()

function! s:Gpsf() abort
  let l:h = "Gpsf"
  let l:c = "git push origin \$(git rev-parse --abbrev-ref HEAD) --force"

  call s:performSimpleGitCommand(l:h, l:c)
endfunction

" Gci: git commit -m '<message>'
command! -nargs=+ Gci call s:Gci(<f-args>)

function! s:Gci(...) abort
  let l:message = join(a:000, ' ')

  let l:h = "Gci"
  let l:c = "git commit -m \"" . l:message . "\""

  call s:performSimpleGitCommand(l:h, l:c)
endfunction

" Gcia: git commit -C HEAD --amend
command! -nargs=? Gcia call s:Gcia()

function! s:Gcia() abort
  let l:h = "Gcia"
  let l:c = "git commit -C HEAD --amend"

  call s:performSimpleGitCommand(l:h, l:c)
endfunction
