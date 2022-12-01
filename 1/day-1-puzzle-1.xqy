xquery version "1.0-ml";

(for $elf in fn:doc("/1/data.xml")/elfs/elf
let $total-food := fn:sum($elf/food/number())
order by $total-food descending
return $total-food)[1]