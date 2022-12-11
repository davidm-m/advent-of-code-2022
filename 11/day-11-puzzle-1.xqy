xquery version "1.0-ml";

declare variable $TEST := fn:false();

declare function local:do-rounds($monkeys, $rounds) {
  if ($rounds eq 0)
  then $monkeys
  else local:do-rounds(local:do-round($monkeys, 1), $rounds - 1)
};

declare function local:do-round($monkeys, $index) {
  if ($index gt fn:count($monkeys))
  then $monkeys
  else (
    let $new-monkey :=
      element monkey {
        attribute inspections { if (fn:empty($monkeys[$index]/@inspections)) then fn:count($monkeys[$index]/item) else $monkeys[$index]/@inspections + fn:count($monkeys[$index]/item)},
        $monkeys[$index]/operation,
        $monkeys[$index]/value,
        $monkeys[$index]/divisor,
        $monkeys[$index]/true,
        $monkeys[$index]/false
      }
    let $increased-scores :=
      if ($monkeys[$index]/operation = "multiply")
      then
        if ($monkeys[$index]/value = "old")
        then $monkeys[$index]/item ! (. * .)
        else $monkeys[$index]/item * $monkeys[$index]/value
      else $monkeys[$index]/item + $monkeys[$index]/value
    let $new-scores := ($increased-scores div 3) ! fn:floor(.)
    let $old-true-monkey := $monkeys[xs:int($monkeys[$index]/true)]
    let $new-true-monkey :=
      element monkey {
        $old-true-monkey/@inspections,
        $old-true-monkey/item,
        $new-scores[. mod $monkeys[$index]/divisor eq 0] ! <item>{.}</item>,
        $old-true-monkey/operation,
        $old-true-monkey/value,
        $old-true-monkey/divisor,
        $old-true-monkey/true,
        $old-true-monkey/false
      }
    let $old-false-monkey := $monkeys[xs:int($monkeys[$index]/false)]
    let $new-false-monkey :=
      element monkey {
        $old-false-monkey/@inspections,
        $old-false-monkey/item,
        $new-scores[(. mod $monkeys[$index]/divisor) ne 0] ! <item>{.}</item>,
        $old-false-monkey/operation,
        $old-false-monkey/value,
        $old-false-monkey/divisor,
        $old-false-monkey/true,
        $old-false-monkey/false
      }
    return
      local:do-round(
        (for $i in 1 to fn:count($monkeys)
        return
          if ($i eq $index)
          then $new-monkey
          else
            if ($i eq $monkeys[$index]/true)
            then $new-true-monkey
            else
              if ($i eq $monkeys[$index]/false)
              then $new-false-monkey
              else $monkeys[$i]),
        $index + 1
      )
  )
};

let $monkeys := (if ($TEST) then fn:doc("/11/test-data.xml") else fn:doc("/11/data.xml"))/monkeys/monkey

let $final-monkeys := local:do-rounds($monkeys, 20)

let $monkey-scores :=
  for $monkey in $final-monkeys
  let $score := xs:int($monkey/@inspections)
  order by $score descending
  return $score

return $monkey-scores[1] * $monkey-scores[2]