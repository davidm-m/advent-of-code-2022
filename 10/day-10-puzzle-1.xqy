xquery version "1.0-ml";

declare variable $TEST := fn:false();

declare function local:process-instruction($instructions, $cycles) {
  if (fn:empty($instructions))
  then $cycles
  else
    if ($instructions[1]/type = "noop")
    then local:process-instruction($instructions[2 to fn:count($instructions)], ($cycles, $cycles[last()]))
    else local:process-instruction(
      $instructions[2 to fn:count($instructions)],
        (
          $cycles,
          $cycles[last()],
          element cycle { $cycles[last()] + $instructions[1]/value }
        )
    )
};

let $instructions := if ($TEST) then fn:doc("/10/test-data.xml")/instructions/instruction else fn:doc("/10/data.xml")/instructions/instruction

let $cycles := local:process-instruction($instructions, <cycle>1</cycle>)

return fn:sum(
  for $i in 1 to 6
  let $cycle-number := 40 * $i - 20
  return $cycles[$cycle-number] * $cycle-number
)