xquery version "1.0-ml";

let $data := fn:doc("/7/data.xml")
let $needed-space := fn:sum($data//size/number()) - 40000000

return
  for $folder in $data//folder
  let $size := fn:sum($folder//size/number())
  where $size gt $needed-space
  order by $size ascending
  return $size