xquery version "1.0-ml";

declare variable $ROCK := 1;
declare variable $PAPER := 2;
declare variable $SCISSORS := 3;

declare variable $LOSE := 1;
declare variable $DRAW := 2;
declare variable $WIN := 3;

declare function local:get-shape($opponent as xs:int, $result as xs:int) as xs:int {
  if ($result = $WIN)
  then if ($opponent + 1 > 3) then 1 else $opponent + 1
  else
    if ($result = $DRAW)
    then $opponent
    else
      if ($result = $LOSE)
      then if ($opponent - 1 < 1) then 3 else $opponent - 1
      else fn:error(xs:QName("INVALID-MATCH"), "Can't work out the move for opponent " || fn:string($opponent) || " and result " || fn:string($result))
};

fn:sum(
    for $match in fn:doc("/2/data.xml")/matches/match
    let $player := local:get-shape($match/opponent, $match/player)
    let $shape-score :=
      if ($player = $ROCK)
      then 1
      else
        if ($player = $PAPER)
        then 2
        else
          if ($player = $SCISSORS)
          then 3
          else fn:error(xs:QName("INVALID-PLAYER"), "Player has made an illegal throw of " || $match/player/string())
    let $outcome-score :=
      if ($match/player = $WIN)
      then 6
      else
        if ($match/player = $DRAW)
        then 3
        else
          if ($match/player = $LOSE)
          then 0
          else fn:error(xs:QName("INVALID-RESULT"), "Invalid match result of " || $match/player/string())
    return $shape-score + $outcome-score
)