xquery version "1.0-ml";

declare variable $TEST := fn:false();

declare function local:compare-packets($left, $right) as xs:boolean? {
  if (fn:empty($left) and fn:empty($right))
  then ()
  else
    if (fn:empty($left))
    then fn:true()
    else
      if (fn:empty($right))
      then fn:false()
      else
        typeswitch ($left[1])
        case element(list) return (
          typeswitch($right[1])
          case element(list) return (local:compare-packets($left[1]/*, $right[1]/*), local:compare-packets($left[2 to fn:count($left)], $right[2 to fn:count($right)]))[1]
          case element(value) return local:compare-packets($left[1]/*, $right[1])
          default return fn:error(xs:QName("WRONG-TYPE"), "right element is invalid type")
        )
        case element(value) return (
          typeswitch($right[1])
          case element(list) return local:compare-packets($left[1], $right[1]/*)
          case element(value) return
            if (xs:int($left[1]) eq xs:int($right[1]))
            then local:compare-packets($left[2 to fn:count($left)], $right[2 to fn:count($right)])
            else xs:int($left[1]) lt xs:int($right[1])
          default return fn:error(xs:QName("WRONG-TYPE"), "right element is invalid type")
        )
        default return fn:error(xs:QName("WRONG-TYPE"), "left element is invalid type")
};

let $pairs := (if ($TEST) then fn:doc("/13/test-data.xml") else fn:doc("/13/data.xml"))/pairs/pair

let $results := $pairs ! local:compare-packets(./packet[1]/*, ./packet[2]/*)

return
  fn:sum(
    for $i in 1 to fn:count($results)
    where $results[$i]
    return $i
  )