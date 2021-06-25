# Cowsay
Tony Monroe's [`cowsay`](https://github.com/schacon/cowsay)
implemented in [Nim](https://nim-lang.org).

# Usage
## CLI
```
$ cowsay -h
Usage:
  main [optional-params] [message: string...]
Cow says things.
Options:
  -h, --help                             print this cligen-erated help
  --help-syntax                          advanced: prepend,plurals,..
  -e=, --eyes=    string  "oo"           set eyes
  -f=, --file=    string  "default.cow"  set file
  -t=, --tongue=  string  "  "           set tongue
  -w=, --wrap=    int     39             set wrap
```

# Example
```
$ cowsay nim
 _____
< nim >
 -----
        \   ^__^
         \  (oo)\_______
            (__)\       )\/\
                ||----w |
                ||     ||
```
