xquery version "1.0-ml";

declare variable $TEST := fn:true();

let $puzzle-input := if ($TEST) then fn:doc("/9/test-input.txt") else fn:doc("/9/input.txt")

let $instructions := fn:tokenize($puzzle-input, "&#10;")

let $instruction-nodes :=
  for $instruction in $instructions
  let $instruction-parts := fn:tokenize($instruction, " ")
  return
    for $i in 1 to xs:int($instruction-parts[2])
    return <instruction>{$instruction-parts[1]}</instruction>

let $output-file := if ($TEST) then "/9/test-data.xml" else "/9/data.xml"

return xdmp:document-insert($output-file, <instructions>{$instruction-nodes}</instructions>)