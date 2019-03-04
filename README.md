# SimpleBash

Some useful bash commands mapped to your vim

## Installing

```vim
call plug#begin()
Plug 'andrewaguiar/simple-bash.vim'
call plug#end()
```

## Commands

  - `Mkdirs <varargs of new dirs>`: Creates multiple directories (directories must be separated by whitespace).
  - `Rename <newName>`: Renames current file / buffer to newName.
  - `Copy <newFile>`: Copies current file / buffer to newFile.
  - `Move <newDir>`: Copies current file / buffer to newDir.
  - `Del`: Deletes current file / buffer.
