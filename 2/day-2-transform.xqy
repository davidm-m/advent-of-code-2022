xquery version "1.0-ml";

declare variable $ROCK := 1;
declare variable $PAPER := 2;
declare variable $SCISSORS := 3;

let $puzzle-input := fn:doc("/2/input.txt")

let $nodes :=
  for $match in fn:tokenize($puzzle-input, "&#10;")[. != ""]
  let $throws := fn:tokenize($match, " ")
  let $opponent :=
    if ($throws[1] = "A")
    then $ROCK
    else
      if ($throws[1] = "B")
      then $PAPER
      else
        if ($throws[1] = "C")
        then $SCISSORS
        else fn:error(xs:QName("INVALID-OPPONENT"), "Opponent has made an illegal throw of " || $throws[1])
  let $player :=
    if ($throws[2] = "X")
    then $ROCK
    else
      if ($throws[2] = "Y")
      then $PAPER
      else
        if ($throws[2] = "Z")
        then $SCISSORS
        else fn:error(xs:QName("INVALID-PLAYER"), "Player has made an illegal throw of " || $throws[2])
  return <match><opponent>{$opponent}</opponent><player>{$player}</player></match>

return xdmp:document-insert("/2/data.xml", <matches>{$nodes}</matches>)