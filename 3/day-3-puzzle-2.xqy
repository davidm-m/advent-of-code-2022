xquery version "1.0-ml";

let $rucksacks := fn:doc("/3/data.xml")/rucksacks/rucksack

let $priorities :=
  for $i in 0 to (fn:count($rucksacks) div 3)
  let $rucksack-one := $rucksacks[3 * $i + 1]
  let $rucksack-two := $rucksacks[3 * $i + 2]
  let $rucksack-three := $rucksacks[3 * $i + 3]
  return $rucksack-one/compartment/item[. = $rucksack-two/compartment/item][. = $rucksack-three/compartment/item][1]/priority

return fn:sum($priorities)