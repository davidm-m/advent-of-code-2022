xquery version "1.0-ml";

import module namespace mem = "http://xqdev.com/in-mem-update" at '/MarkLogic/appservices/utils/in-mem-update.xqy';

declare variable $ROOT := "&#047;";

declare function local:get-current-directory-node($filesystem, $working-directory) {
  if (fn:empty($working-directory))
  then $filesystem
  else local:get-current-directory-node($filesystem/folder[name = $working-directory[1]], $working-directory[2 to fn:count($working-directory)])
};

declare function local:process-line($lines, $filesystem, $working-directory) {
  if (fn:empty($lines))
  then $filesystem
  else
    if (fn:starts-with($lines[1], "$ "))
    then
      if (fn:substring($lines[1], 3, 2) = "cd")
      then
        if (fn:substring-after($lines[1], "cd ") = "..")
        then local:process-line($lines[2 to fn:count($lines)], $filesystem, $working-directory[1 to fn:count($working-directory) - 1])
        else
          if (fn:substring-after($lines[1], "cd ") = $ROOT)
          then local:process-line($lines[2 to fn:count($lines)], $filesystem, $ROOT)
          else local:process-line($lines[2 to fn:count($lines)], $filesystem, ($working-directory, fn:substring-after($lines[1], " cd ")))
      else local:process-line($lines[2 to fn:count($lines)], $filesystem, $working-directory)
    else
      if (fn:starts-with($lines[1], "dir "))
      then local:process-line($lines[2 to fn:count($lines)], mem:node-insert-child(local:get-current-directory-node($filesystem, $working-directory), <folder><name>{fn:substring-after($lines[1], "dir ")}</name></folder>), $working-directory)
      else local:process-line($lines[2 to fn:count($lines)], mem:node-insert-child(local:get-current-directory-node($filesystem, $working-directory), <file><name>{fn:substring-after($lines[1], " ")}</name><size>{fn:substring-before($lines[1], " ")}</size></file>), $working-directory)
};

let $puzzle-input := fn:doc("/7/input.txt")

let $lines := fn:tokenize($puzzle-input, "&#10;")

let $filesystem := <filesystem><folder><name>{$ROOT}</name></folder></filesystem>

return xdmp:document-insert("/7/data.xml", local:process-line($lines[2 to fn:count($lines)], $filesystem, $ROOT))