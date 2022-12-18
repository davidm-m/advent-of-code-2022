xquery version "1.0-ml";

declare variable $TEST := fn:false();

declare function local:split-string($input as xs:string) as xs:string* {
  for $i in 1 to fn:string-length($input)
  return fn:substring($input, $i, 1)
};

declare function local:find-closing-bracket($input as xs:string) {
  let $input-sequence := local:split-string($input)
  return local:find-closing-bracket($input-sequence[2 to fn:count($input-sequence)], 1, 1)
};

declare function local:find-closing-bracket($input as xs:string*, $depth as xs:int, $location as xs:int) {
  if ($depth eq 0)
  then $location
  else
    if ($input[1] eq "[")
    then local:find-closing-bracket($input[2 to fn:count($input)], $depth + 1, $location + 1)
    else
      if ($input[1] eq "]")
      then local:find-closing-bracket($input[2 to fn:count($input)], $depth - 1, $location + 1)
      else local:find-closing-bracket($input[2 to fn:count($input)], $depth, $location + 1)
};

declare function local:convert-packet($packet as xs:string) {
  if ($packet eq "")
  then ()
  else
    if (fn:substring($packet, 1, 1) eq "[")
    then (
      let $closing-location := local:find-closing-bracket($packet)
      return (
        <list>{local:convert-packet(fn:substring($packet, 2, $closing-location - 2))}</list>,
        local:convert-packet(fn:substring($packet, $closing-location + 1))
      )
    )
    else
      if (fn:substring($packet, 1, 1) eq ",")
      then local:convert-packet(fn:substring($packet, 2))
      else (
        let $value :=
          if (fn:substring-before($packet, ",") eq "")
          then $packet
          else fn:substring-before($packet, ",")
        return (
          <value>{$value}</value>,
          local:convert-packet(fn:substring-after($packet, ","))
        )
      )
};

let $puzzle-input := if ($TEST) then fn:doc("/13/test-input.txt") else fn:doc("/13/input.txt")

let $pairs := fn:tokenize($puzzle-input, "&#10;&#10;")

let $pair-nodes :=
  for $pair in $pairs
  let $split-pair := fn:tokenize($pair, "&#10;")
  return
    <pair>
      <packet>{local:convert-packet($split-pair[1])}</packet>
      <packet>{local:convert-packet($split-pair[2])}</packet>
    </pair>

let $output-file := if ($TEST) then "/13/test-data.xml" else "/13/data.xml"

return xdmp:document-insert($output-file, <pairs>{$pair-nodes}</pairs>)