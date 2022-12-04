xquery version "1.0-ml";

fn:count(
    for $pair in fn:doc("/4/data.xml")/pairs/pair
    let $one-sequence := xs:integer($pair/elf[1]/section-start) to xs:integer($pair/elf[1]/section-end)
    let $two-sequence := xs:integer($pair/elf[2]/section-start) to xs:integer($pair/elf[2]/section-end)
    where $one-sequence = $two-sequence
    return 1
)