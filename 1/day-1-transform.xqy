xquery version "1.0-ml";

let $puzzle-input := fn:doc("/1/input.txt")

let $elfs :=
  for $elf in fn:tokenize($puzzle-input, "&#10;&#10;")
  let $food := fn:tokenize($elf, "&#10;")
  let $food-nodes := $food ! <food>{.}</food>
  return <elf>{$food-nodes}</elf>

return xdmp:document-insert("/1/data.xml", <elfs>{$elfs}</elfs>)