# SimpleBash

Some useful bash commands mapped to your vim

## Installing

```vim
call plug#begin()
Plug 'andrewaguiar/simple-bash.vim'
call plug#end()
```

## Commands

### Linux commands

  - `Mkdirs <varargs of new dirs>`: Creates multiple directories (directories must be separated by whitespace).
  - `Rename <newName>`: Renames current file / buffer to newName.
  - `Copy <newFile>`: Copies current file / buffer to newFile.
  - `Move <newDir>`: Moves current file / buffer to newDir.
  - `Del`: Deletes current file / buffer.
  - `Remove <dir/file>`: Deletes dir/file.
  - `New <filename>`: Creates a new file in same dir of current file / buffer.

### Git commands

  - `Ghelp`: shows this list of Git commands
  - `Gbr`: performs a `git branch` and shows the result.
  - `Gst`: performs a `git status --porcelain` and shows the result.
  - `Gco <branch>`: performs a `git checkout <branch>`.
  - `Gcb <new-branch>`: performs a `git checkout -b <new-branch>`.
  - `Gbd <branch>`: performs a `git branch -D <branch>`.
  - `Gdf`: performs a `git diff` and shows the result.
  - `Gdfc`: performs a `git diff --cached` and shows the result.
  - `Ga <files>`: performs a `git add <files> --verbose`.
  - `Gaa`: performs a `git add . --verbose`.
  - `Gr <files>`: performs a `git reset <files>`.
  - `Gra`: performs a `git reset .`.
  - `Gcn <files>`: performs a `git clean -f <files>`.
  - `Gcna`: performs a `git clean -f .`.
  - `Gpl`: performs a `git pull`.
  - `Gft`: performs a `git fetch origin`.
  - `Gps`: performs a `git push origin \$(git rev-parse --abbrev-ref HEAD)`.
  - `Gci <message>`: performs a `git commit -m <message>`.

