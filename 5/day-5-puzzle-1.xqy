xquery version "1.0-ml";

declare variable $STACK-COUNT := 9;

(: Creates a copy of the stacks instead of changing in place, because otherwise MarkLogic will replace the document in the database :)
declare function local:move-crates($stacks, $count as xs:int, $from as xs:int, $to as xs:int) {
  for $i in (1 to $STACK-COUNT)
  return
    if ($i = ($from, $to))
    then
      if ($i = $from)
      then <stack>{$stacks[$i]/crate[$count + 1 to fn:count($stacks[$i]/crate)]}</stack>
      else <stack>{fn:reverse($stacks[$from]/crate[1 to $count])}{$stacks[$i]/crate}</stack>
    else <stack>{$stacks[$i]/crate}</stack>
};

declare function local:execute-instructions($instructions, $stacks) {
  if (fn:empty($instructions))
  then $stacks
  else local:execute-instructions(
      $instructions[2 to fn:count($instructions)],
      local:move-crates($stacks, $instructions[1]/count, $instructions[1]/from, $instructions[1]/to)
  )
};

let $data := fn:doc("/5/data.xml")/puzzle

let $stacks := $data/stacks/stack
let $instructions := $data/instructions/instruction

let $final-stacks := local:execute-instructions($instructions, $stacks)

return fn:string-join($final-stacks ! ./crate[1])