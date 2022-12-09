xquery version "1.0-ml";

let $rows := fn:doc("/8/data.xml")/trees/row

let $visible-trees :=
  for $row in (1 to fn:count($rows))
  return
    for $column in (1 to fn:count($rows[$row]/tree))
    let $above := fn:max($rows[1 to $row - 1]/tree[$column])
    let $below := fn:max($rows[$row + 1 to fn:count($rows)]/tree[$column])
    let $left := fn:max($rows[$row]/tree[1 to $column - 1])
    let $right := fn:max($rows[$row]/tree[$column + 1 to fn:count($rows[1]/tree)])

    let $tree := $rows[$row]/tree[$column]
    let $visible-above := fn:empty($above) or $above lt $tree
    let $visible-below := fn:empty($below) or $below lt $tree
    let $visible-left := fn:empty($left) or $left lt $tree
    let $visible-right := fn:empty($right) or $right lt $tree

    where $visible-above or $visible-below or $visible-left or $visible-right
    return $tree

return fn:count($visible-trees)