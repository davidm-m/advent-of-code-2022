xquery version "1.0-ml";

fn:sum(
  for $rucksack in fn:doc("/3/data.xml")/rucksacks/rucksack
  let $overlap := $rucksack/compartment[1]/item[. = $rucksack/compartment[2]/item][1]
  return $overlap/priority/number()
)