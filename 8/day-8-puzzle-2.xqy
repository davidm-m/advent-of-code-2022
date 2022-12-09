xquery version "1.0-ml";

declare function local:count-sequence($sequence as xs:int*, $compare as xs:int, $count as xs:int) as xs:int {
  if (fn:empty($sequence))
  then $count
  else
    if ($sequence[1] lt $compare)
    then local:count-sequence($sequence[2 to fn:count($sequence)], $compare, $count + 1)
    else $count + 1
};

let $rows := fn:doc("/8/data.xml")/trees/row

let $visible-trees := fn:max(
  for $row in (1 to fn:count($rows))
  return
    for $column in (1 to fn:count($rows[$row]/tree))
    let $tree := $rows[$row]/tree[$column]
    let $above := local:count-sequence(fn:reverse($rows[1 to $row - 1]/tree[$column]), $tree, 0)
    let $below := local:count-sequence($rows[$row + 1 to fn:count($rows)]/tree[$column], $tree, 0)
    let $left := local:count-sequence(fn:reverse($rows[$row]/tree[1 to $column - 1]), $tree, 0)
    let $right := local:count-sequence($rows[$row]/tree[$column + 1 to fn:count($rows[1]/tree)], $tree, 0)

    return $above * $below * $left * $right
)

return $visible-trees