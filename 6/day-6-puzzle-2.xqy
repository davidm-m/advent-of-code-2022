xquery version "1.0-ml";

let $chars := fn:doc("/6/data.xml")/chars/char

return
  for $i in (14 to fn:count($chars))
  where fn:count(fn:distinct-values($chars[$i - 13 to $i])) = 14
  order by $i ascending
  return $i
