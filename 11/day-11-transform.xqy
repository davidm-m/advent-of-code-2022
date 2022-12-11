xquery version "1.0-ml";

declare variable $TEST := fn:false();

let $puzzle-input := if ($TEST) then fn:doc("/11/test-input.txt") else fn:doc("/11/input.txt")

let $monkeys := fn:tokenize($puzzle-input, "&#10;&#10;")

let $monkey-nodes :=
  for $monkey in $monkeys
  let $lines := fn:tokenize($monkey, "&#10;")
  let $items := fn:tokenize(fn:substring-after($lines[2], "items: "), ", ")
  let $operation :=
    if (fn:substring(fn:substring-after($lines[3], "new = old "), 1, 1) = "*")
    then "multiply"
    else "add"
  let $value := fn:substring(fn:substring-after($lines[3], "new = old "), 3)
  let $divisor := fn:substring-after($lines[4], "divisible by ")
  (: Monkeys are zero indexed but xquery isn't :)
  let $true-monkey := xs:int(fn:substring-after($lines[5], " to monkey ")) + 1
  let $false-monkey := xs:int(fn:substring-after($lines[6], " to monkey ")) + 1
  return
    <monkey>
      {$items ! <item>{.}</item>}
      <operation>{$operation}</operation>
      <value>{$value}</value>
      <divisor>{$divisor}</divisor>
      <true>{$true-monkey}</true>
      <false>{$false-monkey}</false>
    </monkey>

let $output-file := if ($TEST) then "/11/test-data.xml" else "/11/data.xml"

return xdmp:document-insert($output-file, <monkeys>{$monkey-nodes}</monkeys>)