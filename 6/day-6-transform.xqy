xquery version "1.0-ml";

declare function local:split-string($string as xs:string) as xs:string* {
  (1 to fn:string-length($string)) ! fn:substring($string, ., 1)
};

let $puzzle-input := fn:doc("/6/input.txt")

let $char-nodes := local:split-string($puzzle-input) ! <char>{.}</char>

return xdmp:document-insert("/6/data.xml", <chars>{$char-nodes}</chars>)