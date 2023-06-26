## dependencies

- zsh
- stow

## configure

open the `config.zsh` file and add or remove files according to your Os.
each entry in the array should hace a directory at the root of this repo

```bash
declare commonPrograms=(...)

declare macOsPrograms=(...)

declare linuxPrograms=(...)

```

## install

at the root of this repo, run:

```bash
./setup.zsh
```
