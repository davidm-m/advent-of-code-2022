xquery version "1.0-ml";

declare variable $TEST := fn:false();

declare function local:split-string($string as xs:string) as xs:string* {
  for $i in 1 to fn:string-length($string)
  return fn:substring($string, $i, 1)
};

let $puzzle-input := if ($TEST) then fn:doc("/12/test-input.txt") else fn:doc("/12/input.txt")

let $lines :=
  for $line in fn:tokenize($puzzle-input, "&#10;")
  let $nodes :=
    for $char in local:split-string($line)
    return
      if ($char eq "S")
      then <square start="true">a</square>
      else
        if ($char eq "E")
        then <square goal="true">z</square>
        else <square>{$char}</square>
  return <row>{$nodes}</row>

let $output-file := if ($TEST) then "/12/test-data.xml" else "/12/data.xml"

return xdmp:document-insert($output-file, <rows>{$lines}</rows>)