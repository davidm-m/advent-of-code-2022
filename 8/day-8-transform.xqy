xquery version "1.0-ml";

let $puzzle-input := fn:doc("/8/input.txt")

let $lines := fn:tokenize($puzzle-input, "&#10;")

let $trees :=
  for $row in $lines
  return <row>{(1 to fn:string-length($row)) ! <tree>{fn:substring($row, ., 1)}</tree>}</row>

return xdmp:document-insert("/8/data.xml", <trees>{$trees}</trees>)