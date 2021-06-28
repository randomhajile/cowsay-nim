from sequtils import concat, map
from strutils import join, multireplace, repeat, splitWhitespace, strip, toLower
from os import absolutePath, fileExists, joinPath, parentDir


let defaultDataDirectory = joinPath(currentSourcePath.parentDir(), "cows")
type
  Cow* = object
    think*: bool
    message*: string
    eyes*: string
    tongue*: string
    wrap*: int
    file*: string


proc joiner(s: seq[string]): string = join(s, " ")


proc getCowPath(f: string): string =
  let path = absolutePath(f)
  if fileExists(path):
    return path

  return joinPath(defaultDataDirectory, f)


proc fill(s: string, filler: string, total: int): string =
  result = s
  while len(result) < total:
    result &= filler


proc chunk(s: string, size: int): seq[string] =
  ## Returns a sequence of strings each no more than size "size" while
  ## attempting to respect whitespace boundaries.
  let pieces = splitWhitespace(s)
  var
    current: seq[string] = @[]
    currentLength = 0

  for piece in pieces:
    if len(current) > 0 and len(piece) + currentLength > size:
      result.add(joiner(current))
      current = @[]
      currentLength = 0

    var workingPiece = piece
    while len(workingPiece) > size:
      result.add(@[workingPiece[0 ..< size]])
      workingPiece = piece[size ..< len(workingPiece)]

    current.add(workingPiece)
    currentLength += len(workingPiece) + 1

  result.add(joiner(current))


proc formatCow(cow: Cow, contents: string): string =
  ## Formats the contents of a cowfile based on the parameters on the given
  ## cow object.
  let replacements = [
    ("$thoughts", if cow.think: "o" else: "\\"),
    ("$eyes", cow.eyes),
    ("$tongue", cow.tongue),
  ]
  result = multireplace(contents, replacements)


proc thoughtBubbleText(pieces: seq[string]): string =
  join(
    map(pieces, proc(x: string): string = "( " & x & " )\n"),
    ""
  )


proc speechBubbleText(pieces: seq[string]): string =
  if len(pieces) == 1:
    return "< " & pieces[0] & " >\n"

  result = "/ " & pieces[0] & " \\\n"
  result &= join(
    map(pieces[1 ..< ^1], proc(x: string): string = "| " & x & " |\n"),
    ""
  )
  result &= "\\ " & pieces[^1] & " /\n"


proc bubble(cow: Cow): string =
  ## Formats the bubble for the cow.
  var pieces = chunk(cow.message, cow.wrap)
  let
    length = max(map(pieces, proc(x: string): int = len(x)))
    top = " _" & '_'.repeat(length) & "_\n"
    bottom = " -" & '-'.repeat(length) & "-\n"

  pieces = map(pieces, proc(x: string): string = fill(x, " ", length))
  let body = if cow.think:
               thoughtBubbleText(pieces)
             else:
               speechBubbleText(pieces)

  return top & body & bottom


proc say*(cow: Cow): string =
  ## Returns a string representation of the cowsay.
  let
    cowFile = getCowPath(cow.file)
    contents = readFile(cowFile)
    cowString = cow.formatCow(contents)
    bubble = cow.bubble

  return bubble & cowString
