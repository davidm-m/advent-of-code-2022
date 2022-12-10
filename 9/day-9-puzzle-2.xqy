xquery version "1.0-ml";

declare variable $TEST := fn:true();

declare function local:get-tail($head, $tail, $name) {
  let $x-diff := $head/@x - $tail/@x
  let $y-diff := $head/@y - $tail/@y

  let $new-x :=
    if ($x-diff = 2 or ($x-diff = 1 and $y-diff = (-2, 2)))
    then $tail/@x + 1
    else
      if ($x-diff = -2 or ($x-diff = -1 and $y-diff = (-2, 2)))
      then $tail/@x - 1
      else $tail/@x
  let $new-y :=
    if ($y-diff = 2 or ($y-diff = 1 and $x-diff = (-2, 2)))
    then $tail/@y + 1
    else
      if ($y-diff = -2 or ($y-diff = -1 and $x-diff = (-2, 2)))
      then $tail/@y - 1
      else $tail/@y

  return element {$name} { attribute x {$new-x}, attribute y {$new-y} }
};

declare function local:process-instruction($instructions, $positions) {
  if (fn:empty($instructions))
  then $positions
  else (
    let $new-head :=
      if ($instructions[1] = "U")
      then element head { attribute x {$positions[last()]/head/@x}, attribute y {$positions[last()]/head/@y + 1} }
      else
        if ($instructions[1] = "R")
        then element head { attribute x {$positions[last()]/head/@x + 1}, attribute y {$positions[last()]/head/@y} }
        else
          if ($instructions[1] = "D")
          then element head { attribute x {$positions[last()]/head/@x}, attribute y {$positions[last()]/head/@y - 1} }
          else element head { attribute x {$positions[last()]/head/@x - 1}, attribute y {$positions[last()]/head/@y} }
    let $new-one := local:get-tail($new-head, $positions[last()]/one, "one")
    let $new-two := local:get-tail($new-one, $positions[last()]/two, "two")
    let $new-three := local:get-tail($new-two, $positions[last()]/three, "three")
    let $new-four := local:get-tail($new-three, $positions[last()]/four, "four")
    let $new-five := local:get-tail($new-four, $positions[last()]/five, "five")
    let $new-six := local:get-tail($new-five, $positions[last()]/six, "six")
    let $new-seven := local:get-tail($new-six, $positions[last()]/seven, "seven")
    let $new-eight := local:get-tail($new-seven, $positions[last()]/eight, "eight")
    let $new-nine := local:get-tail($new-eight, $positions[last()]/nine, "nine")
    return local:process-instruction($instructions[2 to fn:count($instructions)], ($positions, <position>{($new-head, $new-one, $new-two, $new-three, $new-four, $new-five, $new-six, $new-seven, $new-eight, $new-nine)}</position>))
  )
};

let $filename := if ($TEST) then "/9/test-data.xml" else "/9/data.xml"

let $positions := local:process-instruction(fn:doc($filename)/instructions/instruction, <position>
  <head x="0" y="0"></head>
  <one x="0" y="0"></one>
  <two x="0" y="0"></two>
  <three x="0" y="0"></three>
  <four x="0" y="0"></four>
  <five x="0" y="0"></five>
  <six x="0" y="0"></six>
  <seven x="0" y="0"></seven>
  <eight x="0" y="0"></eight>
  <nine x="0" y="0"></nine>
</position>)

let $tail-positions := fn:distinct-values($positions/nine ! (./@x || "," || ./@y))

return fn:count($tail-positions)