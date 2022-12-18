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

declare function local:sort($packets) {
  if (fn:count($packets) eq 1)
  then $packets
  else (
    let $sorted := local:sort($packets[2 to fn:count($packets)])
    let $index :=
      fn:min(
        for $i in 1 to fn:count($sorted)
        where local:compare-packets($packets[1]/*, $sorted[$i]/*)
        return $i
      )
    return
      for $i in 1 to fn:count($packets)
      return
        if ($i eq $index)
        then $packets[1]
        else
          if ($i lt $index)
          then $sorted[$i]
          else $sorted[$i - 1]
  )
};

declare function local:string-convert($packet) {
  if (fn:empty($packet))
  then ()
  else
    typeswitch ($packet)
    case element(list) return "[" || fn:string-join(($packet/* ! local:string-convert(.))) || "]"
    case element(value) return fn:string($packet) || ","
    default return fn:error(xs:QName("WRONG-TYPE"), "element is invalid type")
};

let $packets := (if ($TEST) then fn:doc("/13/test-data.xml") else fn:doc("/13/data.xml"))/pairs/pair/packet

let $divider-one := <packet><list><list><value>2</value></list></list></packet>
let $divider-two := <packet><list><list><value>6</value></list></list></packet>


let $sorted := local:sort(($packets, $divider-one, $divider-two))

let $sorted-strings := $sorted ! local:string-convert(./*)
let $first-index := fn:index-of($sorted-strings, "[[2,]]")
let $second-index := fn:index-of($sorted-strings, "[[6,]]")

return $first-index * $second-index

