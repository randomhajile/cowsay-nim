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

# CLI Example
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

# Package Example
Add `cowsay` to your `.nimble` file, then you can import it as follows.
```nim
import cowsaypkg/cowsay

when isMainModule:
  let c = Cow(
      think: false,
      message: "Hello, world!",
      eyes: "oo",
      tongue: "  ",
      wrap: 39,
      file: "stegosaurus.cow"
  )
  echo c.say()
```
