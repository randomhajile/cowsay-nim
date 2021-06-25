import cowsaypkg/cowsay

proc main(eyes = "oo", file = "default.cow", tongue = "  ", wrap = 39,
    message: seq[string]): int =
  let
    toDisplay = if len(message) == 0: stdin.readAll else: message[0]
    c = Cow(
      think: true,
      message: toDisplay,
      eyes: eyes,
      tongue: tongue,
      wrap: wrap,
      file: file
    )
  echo cowsay.say(c)
  return 0

when isMainModule:
  import cligen
  dispatch(main, doc = "Cow thinks things.")
