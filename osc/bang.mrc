on ^@!*:text:*:#: { if ($nick isreg #) { $_c($1-) } }
on ^@!*:notice:*:#: { if ($nick isreg #) { $_c($1-) } }
on ^@!*:action:*:#: { if ($nick isreg #) { $_c($1-) } }
on @!*:ctcpreply:*: { if ($nick isreg #) { $_c($1-) } }
ctcp @!*:*:*: { if ($nick isreg #) { $_c($1-) } }
alias -l _c { 
  if ($_p($1-) != false) {     
    .hinc -mu15 limit #
    if ($hget(limit,#) < 22 ) { !.quote -mc kick # $nick $_p($1-) }
  }
  .halt 
}
;if ($hget(limit,#) < 22 ) { !.quote -mc kick # $nick $replace($lower( $+ $color(kick) FLOODING  $+ $_p($1-) $+  IS NOT ALLOWED HERE. ‹‹‹ $+ $nick $+ ››› THIS CODE IS PROVIDED BY THE BängkäI.InC. Copyright 2004 by bangkai <bangkai22@yahoo.com>. All rights reserved.),@,@,.,.,<,<,>,>) }
alias -l _p {  
  .hinc -mu5 repeat [ $+ [ # ] $+ [ $nick ] ] $hash($remove($strip($1-),$chr(160),$chr(32)),32) 1 
  .hinc -mu5 row [ $+ [ # ] ] $nick 1 
  if ($event == ctcpreply) { .return ctcpreply }
  if ($event == ctcp) { .return ctcp }
  if ($regex($1-,/[[:cntrl:]]/g) > 49) { .return cntrl }
  if ($regex($1-,/[[:upper:]]/g) > 49) { .return upper }
  if ($regex($1-,/[[:digit:]]/g) > 49) { .return numeric }
  if ($regex($1-,/[[:punct:]]/g) > 49) { .return punct }
  if ($regex($1-,/[€-Ÿ|¡-ÿ]/g) > 49) { .return ascii }
  if ($regex($1-,/[[:alnum:]]/g) > 199) { .return charc }
  if ($regex($1-,/[ $chr(160) ]/g) > 49) { .return blank }
  if ($regex($lower($strip($1-)),/(babi|burit|sex|pepek|kimak|kelentit|kotey|kote|pelir|lancau|cibai|pantat|gampang|sial|cipap|jubur|anjing|puki|pepek|sundal|pundek|butuh|konek|suck|fuck)/g) > 0) { .return taboo }
  if ($regex($lower($strip($1-)),/(#|http://|ftp:|/server)/g) > 0) { .return spam }
  if ($hget(repeat [ $+ [ # ] $+ [ $nick ] ],$hash($remove($strip($1-),$chr(160),$chr(32)),32)) > 2) { .return repeat }
  if ($hget(row [ $+ [ # ] ],$nick) > 4) { .return row } 
  .return false
}
;raw *:*: { .halt }
;raw *:*: { .window @Raw | .echo @Raw $numeric : $1- | .halt }
raw 001:*:{ halt }
raw 002:*:{ halt }
raw 003:*:{ halt }
raw 004:*:{ halt }
raw 005:*:{ halt }
raw 006:*:{ halt }
raw 007:*:{ halt }
raw 008:*:{ halt }
raw 009:*:{ halt }
raw 249:*:{ halt }
raw 251:*:{ halt }
raw 252:*:{ halt }
raw 253:*:{ halt }
raw 254:*:{ halt }
raw 255:*:{ halt }
raw 265:*:{ halt }
raw 266:*:{ halt }
raw 494:*:{ halt }
raw 353:*:{ halt }
raw 367:*:{ halt }
raw 368:*:{ halt }
raw 401:*:{ halt }
raw 441:*:{ halt }
raw 442:*:{ halt }
raw 375:*:{ halt }
raw 376:*:{ halt }
raw 372:*:{ halt }
raw 302:*:{ halt }
raw 478:*:{ halt }
raw 366:*:{ halt } 
on ^*:JOIN:#: { .halt }
on ^*:PART:#: { .halt }
on ^*:QUIT: { .echo $color(quit) 15[ QUIT 15] 3•  $nick $1- | .halt }
on ^*:RAWMODE:#: { .echo $color(mode) # 15[ Mode 15] 3• $nick set $1- | .halt }
on ^*:KICK:#: { .echo $color(kick) # 15[ Kick 15] 3• $knick was kicked by $nick : $1- | .halt }
