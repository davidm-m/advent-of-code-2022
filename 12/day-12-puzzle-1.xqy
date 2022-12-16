(: This is really bad - so much string manipulation. I should have tried to do it with actual xml :)

xquery version "1.0-ml";

declare variable $TEST := fn:false();

declare function local:can-travel($from as xs:string, $to as xs:string) as xs:boolean {
  (fn:string-to-codepoints($to) - fn:string-to-codepoints($from)) le 1
};

declare function local:dijkstra($visited, $unvisited, $current, $adjacency-map) {
  if (fn:empty($unvisited))
  then $visited
  else (
    let $current-distance := xs:int(fn:tokenize($unvisited[fn:starts-with(., $current || ":")], ":")[2])
    let $neighbours := map:get($adjacency-map, $current)
    let $new-visited := ($visited, $unvisited[fn:starts-with(., $current || ":")])
    let $new-unvisited :=
      for $square in $unvisited
      let $is-neighbour :=
        fn:not(fn:empty(
          for $neighbour in $neighbours
          where fn:starts-with($square, $neighbour || ":")
          return fn:true()
        ))
      where fn:not(fn:starts-with($square, $current || ":"))
      return
        if ($is-neighbour)
        then
          if (xs:int(fn:tokenize($square, ":")[2]) le $current-distance + 1)
          then $square
          else fn:tokenize($square, ":")[1] || ":" || fn:string($current-distance + 1)
        else $square
    let $new-current := (
      for $square in $new-unvisited
      order by xs:int(fn:tokenize($square, ":")[2])
      return fn:tokenize($square, ":")[1]
    )[1]
    return local:dijkstra($new-visited, $new-unvisited, $new-current, $adjacency-map)
  )
};

let $rows := if ($TEST) then fn:doc("/12/test-data.xml")/rows/row else fn:doc("/12/data.xml")/rows/row

let $adjacency-map := map:map()

let $_ :=
  for $row in 1 to fn:count($rows)
  return
    for $column in 1 to fn:count($rows[$row]/square)
    let $up :=
      if (local:can-travel($rows[$row]/square[$column], $rows[$row - 1]/square[$column]))
      then fn:string($row - 1) || "," || fn:string($column)
      else ()
    let $left :=
      if (local:can-travel($rows[$row]/square[$column], $rows[$row]/square[$column - 1]))
      then fn:string($row) || "," || fn:string($column - 1)
      else ()
    let $down :=
      if (local:can-travel($rows[$row]/square[$column], $rows[$row + 1]/square[$column]))
      then fn:string($row + 1) || "," || fn:string($column)
      else ()
    let $right :=
      if (local:can-travel($rows[$row]/square[$column], $rows[$row]/square[$column + 1]))
      then fn:string($row) || "," || fn:string($column + 1)
      else ()
    return map:put($adjacency-map, fn:string($row) || "," || fn:string($column), ($up, $down, $left, $right))

let $start-row :=
  for $row in 1 to fn:count($rows)
  where fn:not(fn:empty($rows[$row]/square[@start eq "true"]))
  return $row
let $start-column :=
  for $column in 1 to fn:count($rows[$start-row]/square)
  where $rows[$start-row]/square[$column]/@start eq "true"
  return $column

let $goal-row :=
  for $row in 1 to fn:count($rows)
  where fn:not(fn:empty($rows[$row]/square[@goal eq "true"]))
  return $row
let $goal-column :=
  for $column in 1 to fn:count($rows[$goal-row]/square)
  where $rows[$goal-row]/square[$column]/@goal eq "true"
  return $column

let $start-unvisited :=
  for $row in 1 to fn:count($rows)
  return
    for $column in 1 to fn:count($rows[$row]/square)
    return
      if ($row eq $start-row and $column eq $start-column)
      then fn:string($row) || "," || fn:string($column) || ":0"
      else fn:string($row) || "," || fn:string($column) || ":10000"

let $all-distances := local:dijkstra((), $start-unvisited, fn:string($start-row) || "," || fn:string($start-column), $adjacency-map)

return $all-distances[fn:starts-with(., fn:string($goal-row) || "," || fn:string($goal-column) || ":")]