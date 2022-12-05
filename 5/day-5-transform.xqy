xquery version "1.0-ml";

declare variable $STACK-COUNT := 9;
declare variable $MAX-STACK-HEIGHT := 8;

declare function local:add-to-map($map, $key as xs:string, $addition) {
  if ($addition = " ")
  then ()
  else map:put($map, $key, (map:get($map, $key), $addition))
};

(: (count, from, to) :)
declare function local:get-instructions($instruction) {
  let $count := fn:substring-before(fn:substring-after($instruction, "move "), " from")
  let $from := fn:substring-before(fn:substring-after($instruction, "from "), " to")
  let $to := fn:substring-after($instruction, " to ")
  return ($count, $from, $to)
};

let $puzzle-input := fn:doc("/5/input.txt")

let $stacks := fn:tokenize($puzzle-input, "&#10;&#10;")[1]
let $instructions := fn:tokenize($puzzle-input, "&#10;&#10;")[2]

let $stack-map := map:map()

let $_ :=
  for $line in fn:tokenize($stacks, "&#10;")[1 to $MAX-STACK-HEIGHT]
  return (1 to $STACK-COUNT) ! local:add-to-map($stack-map, fn:string(.), fn:substring($line, (. * 4 - 2), 1))

let $stack-nodes :=
  for $key in map:keys($stack-map)
  let $stack := map:get($stack-map, $key) ! <crate>{.}</crate>
  order by $key ascending
  return <stack>{$stack}</stack>

let $instruction-nodes :=
  for $line in fn:tokenize($instructions, "&#10;")
  let $values := local:get-instructions($line)
  return <instruction><count>{$values[1]}</count><from>{$values[2]}</from><to>{$values[3]}</to></instruction>

return xdmp:document-insert("/5/data.xml", <puzzle><stacks>{$stack-nodes}</stacks><instructions>{$instruction-nodes}</instructions></puzzle>)