# Package

version       = "0.1.0"
author        = "Mike Hampton"
description   = "A Nim implementation of cowsay."
license       = "MIT"
srcDir        = "src"
installExt    = @["nim", "cow"]
bin           = @["cowsay", "cowthink"]


# Dependencies

requires "nim >= 1.4.8", "cligen"
