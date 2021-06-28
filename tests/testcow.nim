import cowsaypkg/cowsay
import osProc
import strformat
import strutils
import unittest
from sequtils import map
from os import splitFile, walkFiles

const
  think = false
  message = "Hello, world!"
  eyes = "oo"
  tongue = "  "
  wrap = 39


proc getRealCowsay(fname: string, think: bool, message: string): string =
  ## Invokes the system's `cow(say|think)` command and returns the output.
  ## Uses poEvalCommand because I had issues with cowthink on Ubuntu in tests.
  let cmd = if think: "cowthink" else: "cowsay"
  return map(
    execProcess(
      &"{cmd} -f {fname} -e oo '{message}'",
      options = {poUsePath, poEvalCommand}
  ).splitLines(),
    proc(x: string): string = x.strip(leading = false),
  ).join("\n").replace("\t", "        ").strip


test "hello world matches real cowsay":
  for fname in walkFiles("src/cowsaypkg/cows/*.cow"):
    let (_, cowName, _) = splitFile(fname)
    for think in [true, false]:
      let
        expected = getRealCowsay(cowName & ".cow", think, message)
        c = Cow(
          think: think,
          message: message,
          eyes: eyes,
          tongue: tongue,
          wrap: wrap,
          file: $cowName & ".cow"
        )
      check c.say.strip == expected

test "matches real cowsay on reasonable text":
  const
    messages = @[
      "The Donkey-Headed Adversary of Humanity opens the discussion.",
      "Doc, note: I dissent. A fast never prevents a fatness. I diet on cod.",
    ]
  for think in [true, false]:
    for message in messages:
      let
        expected = getRealCowsay("default.cow", think, message)
        c = Cow(
          think: think,
          message: message,
          eyes: eyes,
          tongue: tongue,
          wrap: wrap,
          file: "default.cow"
        )
      check c.say.strip == expected

test "matches real cowsay on unreasonable text":
  const
    messages = [
      "aaaaaaa aaaaaaaaaaa aaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
    ]
  for think in [true, false]:
    for message in messages:
      let
        expected = getRealCowsay("default.cow", think, message)
        c = Cow(
          think: think,
          message: message,
          eyes: eyes,
          tongue: tongue,
          wrap: wrap,
          file: "default.cow"
        )
      check c.say.strip == expected
