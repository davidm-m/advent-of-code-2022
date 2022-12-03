xquery version "1.0-ml";

declare function local:get-priority($item) as xs:int {
  let $codepoint := fn:string-to-codepoints($item)
  return
    if ($codepoint >= 97)
    then $codepoint - 96
    else $codepoint - 38
};

declare function local:char-split($string) {
  fn:string-to-codepoints($string) ! fn:codepoints-to-string(.)
};

let $puzzle-input := fn:doc("/3/input.txt")

let $rucksacks :=
  for $rucksack in fn:tokenize($puzzle-input, "&#10;")
  let $items := local:char-split($rucksack)
  let $item-nodes :=
    for $item in $items
    let $priority := local:get-priority($item)
    return <item><type>{$item}</type><priority>{$priority}</priority></item>
  return
    <rucksack>
      <compartment>{$item-nodes[1 to (fn:count($items) div 2)]}</compartment>
      <compartment>{$item-nodes[(fn:count($items) div 2) + 1 to fn:count($items)]}</compartment>
    </rucksack>

return xdmp:document-insert("/3/data.xml", <rucksacks>{$rucksacks}</rucksacks>)