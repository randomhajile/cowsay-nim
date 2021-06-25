import cowsaypkg/cowsay
import osProc
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


proc getRealCowsay(fname, message: string): string =
  return map(
    execProcess(
      "cowsay",
      args = [
        "-f", fname,
        "-e", "oo",
        message
    ],
    options = {poUsePath}
  ).splitLines(),
    proc(x: string): string = x.strip(leading = false),
  ).join("\n").replace("\t", "        ").strip


test "hello world matches real cowsay":
  for fname in walkFiles("data/*.cow"):
    let
      (_, cowName, _) = splitFile(fname)
      expected = getRealCowsay(cowName & ".cow", message)
      c = Cow(
        think: think,
        message: message,
        eyes: eyes,
        tongue: tongue,
        wrap: wrap,
        file: $cowName & ".cow"
      )
    check c.say.strip == expected

test "works correctly on reasonable text":
  const
    message = "The Donkey-Headed Adversary of Humanity opens the discussion."
  let
    expected = getRealCowsay("default.cow", message)
    c = Cow(
      think: think,
      message: message,
      eyes: eyes,
      tongue: tongue,
      wrap: wrap,
      file: "default.cow"
    )
  check c.say.strip == expected

test "works correctly on unreasonable text":
  const
    message = "aaaaaaa aaaaaaaaaaa aaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaa aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
  let
    expected = getRealCowsay("default.cow", message)
    c = Cow(
      think: think,
      message: message,
      eyes: eyes,
      tongue: tongue,
      wrap: wrap,
      file: "default.cow"
    )
  check c.say.strip == expected
