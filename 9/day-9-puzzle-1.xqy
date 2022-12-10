xquery version "1.0-ml";

declare variable $TEST := fn:true();

declare function local:get-tail($head, $tail) {
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

  return element tail { attribute x {$new-x}, attribute y {$new-y} }
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
    let $new-tail := local:get-tail($new-head, $positions[last()]/tail)
    return local:process-instruction($instructions[2 to fn:count($instructions)], ($positions, <position>{($new-head, $new-tail)}</position>))
  )
};

let $filename := if ($TEST) then "/9/test-data.xml" else "/9/data.xml"

let $positions := local:process-instruction(fn:doc($filename)/instructions/instruction, <position><head x="0" y="0"></head><tail x="0" y="0"></tail></position>)

let $tail-positions := fn:distinct-values($positions/tail ! (./@x || "," || ./@y))

return fn:count($tail-positions)