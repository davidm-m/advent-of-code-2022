xquery version "1.0-ml";

declare variable $ROCK := 1;
declare variable $PAPER := 2;
declare variable $SCISSORS := 3;

declare function local:resolve-match($player, $opponent) as xs:int {
  if ($player = ($opponent + 1, $opponent - 2))
  then 6
  else
    if ($player = $opponent)
    then 3
    else
      if ($player = ($opponent - 1, $opponent + 2))
      then 0
      else fn:error(xs:QName("INVALID-MATCH"), "Can't work out the result of player " || fn:string($player) || " vs opponent " || fn:string($opponent))
};

fn:sum(
    for $match in fn:doc("/2/data.xml")/matches/match
    let $shape-score :=
      if ($match/player = $ROCK)
      then 1
      else
        if ($match/player = $PAPER)
        then 2
        else
          if ($match/player = $SCISSORS)
          then 3
          else fn:error(xs:QName("INVALID-PLAYER"), "Player has made an illegal throw of " || $match/player/string())
    let $outcome-score := local:resolve-match($match/player/number(), $match/opponent/number())
    return $shape-score + $outcome-score
)
