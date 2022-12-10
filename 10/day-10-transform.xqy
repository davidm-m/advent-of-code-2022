xquery version "1.0-ml";

declare variable $TEST := fn:false();

let $puzzle-input := if ($TEST) then fn:doc("/10/test-input.txt") else fn:doc("/10/input.txt")

let $instructions := fn:tokenize($puzzle-input, "&#10;")

let $instruction-nodes :=
  for $instruction in $instructions
  let $split-instruction := fn:tokenize($instruction, " ")
  return
    if (fn:empty($split-instruction[2]))
    then <instruction><type>{$split-instruction[1]}</type></instruction>
    else <instruction><type>{$split-instruction[1]}</type><value>{$split-instruction[2]}</value></instruction>

let $output-file := if ($TEST) then "/10/test-data.xml" else "/10/data.xml"
return xdmp:document-insert($output-file, <instructions>{$instruction-nodes}</instructions>)