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
  - `Move <newDir>`: Copies current file / buffer to newDir.
  - `Del`: Deletes current file / buffer.

### Git commands

  - `Gst`: performs a `git status --porcelain` and shows the result.
  - `Gco <branch>`: performs a `git checkout <branch>`.
  - `Gcb <new-branch>`: performs a `git checkout -b <new-branch>`.
  - `Gdf`: performs a `git diff` and shows the result.
  - `Gdfc`: performs a `git diff --cached` and shows the result.
  - `Ga <files>`: performs a `git add <files> --verbose`.
  - `Gaa`: performs a `git add . --verbose`.
