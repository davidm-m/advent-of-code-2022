xquery version "1.0-ml";

let $puzzle-input := fn:doc("/4/input.txt")

let $pairs :=
  for $pair in fn:tokenize($puzzle-input, "&#10;")
  let $one := fn:tokenize($pair, ",")[1]
  let $two := fn:tokenize($pair, ",")[2]
  let $one-node := <elf><section-start>{fn:tokenize($one, "-")[1]}</section-start><section-end>{fn:tokenize($one, "-")[2]}</section-end></elf>
  let $two-node := <elf><section-start>{fn:tokenize($two, "-")[1]}</section-start><section-end>{fn:tokenize($two, "-")[2]}</section-end></elf>
  return <pair>{$one-node}{$two-node}</pair>

return xdmp:document-insert("/4/data.xml", <pairs>{$pairs}</pairs>)