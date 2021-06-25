from sequtils import concat, map
from strutils import join, multireplace, repeat, splitWhitespace, toLower
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
    if len(piece) + currentLength > size:
      result.add(joiner(current))
      current = @[]
      currentLength = 0

    var workingPiece = piece
    while len(workingPiece) > size:
      result.add(@[workingPiece[0 ..< size]])
      workingPiece = piece[size ..< len(workingPiece)]

    current.add(workingPiece)
    currentLength += len(workingPiece)

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


proc bubble(cow: Cow): string =
  ## Formats the bubble for the cow.
  var pieces = chunk(cow.message, cow.wrap)
  let
    length = max(map(pieces, proc(x: string): int = len(x)))
    top = " _" & '_'.repeat(length) & "_\n"
    bottom = " -" & '-'.repeat(length) & "-\n"

  pieces = map(pieces, proc(x: string): string = fill(x, " ", length))
  if len(pieces) == 1:
    return top & "< " & pieces[0] & " >\n" & bottom

  var body = ""
  body &= "/ " & pieces[0] & " \\\n"
  for piece in pieces[1 ..< len(pieces) - 1]:
    body &= "| " & piece & " |\n"
  body &= "\\ " & pieces[^1] & " /\n"

  return top & body & bottom


proc say*(cow: Cow): string =
  ## Returns a string representation of the cowsay.
  let
    cowFile = getCowPath(cow.file)
    contents = readFile(cowFile)
    cowString = cow.formatCow(contents)
    bubble = cow.bubble

  return bubble & cowString
