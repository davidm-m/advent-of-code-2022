#!/bin/bash

for day in {1..25}
do
  if [ ! -d "$day" ]; then
    mkdir "$day"
    echo "xquery version \"1.0-ml\";

let \$puzzle-input := fn:doc(\"/$day/input.txt\")" > "$day"/"day-$day-transform.xqy"
    echo 'xquery version "1.0-ml";' > "$day"/"day-$day-puzzle-1.xqy"
    echo 'xquery version "1.0-ml";' > "$day"/"day-$day-puzzle-2.xqy"
  fi
done
