xquery version "1.0-ml";

fn:sum(
    for $folder in fn:doc("/7/data.xml")//folder
    let $size := fn:sum($folder//size/number())
    where $size le 100000
    return $size
)