on ^@!*:text:*:#: { if ($nick isreg #) && ($nsx($1-)) { .hinc -mu5 k a 1 | if ($hget(k,a) isnum 22-42) { .raw -qmcH kick # $nick × $nsx($1-) on $event × %r × | .signal -n pro.ban # $nick } | halt } }
on ^@!*:notice:*:#: { if ($nick isreg #) && ($nsx($1-)) { .hinc -mu5 k a 1 | if ($hget(k,a) isnum 22-42) { .raw -qmcH kick # $nick × $nsx($1-) on $event × %r × | .signal -n pro.ban # $nick } | halt } }
on ^@!*:action:*:#: { if ($nick isreg #) && ($nsx($1-)) { .hinc -mu5 k a 1 | if ($hget(k,a) isnum 22-42) { .raw -qmcH kick # $nick × $nsx($1-) on $event × %r × | .signal -n pro.ban # $nick } | halt } }
;on ^@!*:text:*:#: { if ($nick isreg #) && ($nsx($1-)) { $iif(%kx > 20,halt,.inc -u10 %kx 1) | .raw -qmcH kick # $nick × $nsx($1-) $event × %r × | .signal -n pro.ban # $nick } | halt }
;on ^@!*:notice:*:#: { if ($nick isreg #) && ($nsx($1-)) { $iif(%kx > 20,halt,.inc -u10 %kx 1) | .raw -qmcH kick # $nick × $nsx($1-) $event × %r × | .signal -n pro.ban # $nick } | halt }
;on ^@!*:action:*:#: { if ($nick isreg #) && ($nsx($1-)) { $iif(%kx > 20,halt,.inc -u10 %kx 1) | .raw -qmcH kick # $nick × $nsx($1-) $event × %r × | .signal -n pro.ban # $nick } | halt }
on @!*:ctcpreply:*: { if ($nick isreg #) { $iif(%kx > 20,halt,.inc -u10 %kx 1) | !.quote -mc kick # $nick × faulty $event × %r × | .signal -n pro.ban # $nick | .halt } }
ctcp @!*:*:*: { if ($nick isreg #) { $iif(%kx > 20,halt,.inc -u10 %kx 1) | !.quote -mc kick # $nick × faulty $event × %r × | .signal -n pro.ban # $nick | .halt } }
on 1:signal:pro.ban:{
  .hadd -u5m b $+($2,!*@*n3w*) 
  .timerb1 1 4 !.mode $1 $+(+,$str(b,$hget(b,0).item)) $hget(b,1).item $hget(b,2).item $hget(b,3).item $hget(b,4).item $hget(b,5).item $hget(b,6).item $hget(b,7).item $hget(b,8).item $hget(b,9).item $hget(b,10).item $hget(b,11).item $hget(b,12).item
  .timerb2 1 10 !.mode $1 $+(+,$str(b,$calc($hget(b,0).item - 12))) $hget(b,13).item $hget(b,14).item $hget(b,15).item $hget(b,16).item $hget(b,17).item $hget(b,18).item $hget(b,19).item $hget(b,20).item $hget(b,21).item $hget(b,22).item $hget(b,23).item $hget(b,24).item
}
on *:deop:#:{ if ($opnick == $me) && ($nick != $me) { .timerop2 1 1 msg # !op | .timerop 1 1 cs op # $me } }
;$iif($hget(x,lt) == adv,$ü(inviter),$iif($hget(x,lt) == bad,$ü(swear),$iif($regex($hget(x,at),/[[:cntrl:]]/g) >= 50,$ü(codes),$iif($regex($hget(x,st),/[[:upper:]]/g) >= 50,$ü(caps),$iif($regex($hget(x,st),/[[:digit:]]/g) >= 50,$ü(numerics),$iif($regex($hget(x,st),/[ $+ $chr(44) $+ ]/g) >= 50,$ü(aphostropes),$iif($regex($hget(x,st),/[[:punct:]]/g) >= 50,$ü(shift),$iif($regex($hget(x,st),/[€-Ÿ|¡-ÿ]/g) >= 50,$ü(asciis),$iif($regex($hget(x,st),/./g) >= 200,$ü(characters),$iif($regex($hget(x,st),/[ $+ $chr(160) $+ ]/g) >= 50,$ü(blanks),$iif($hget(x,$hash($+(#,$nick,$remove($hget(x,st),$chr(160),$chr(32))),32)) >= 3,$ü(repeats),$iif($hget(x,$hash($+(#,$nick),32)) >= 5,$ü(lines),goto echo))))))))))))
on 1:signal:pro.arm:{ hinc -mu2 pro $+($1,$2-) | hinc -mu2 pro $1 }
alias -l nsx {  
  if ($regex($1-,/(?:[[:cntrl:]])/g) > 49) { .return excessive cntrl }
  if ($regex($1-,/(?:[[:upper:]])/g) > 49) { .return excessive upper }
  if ($regex($1-,/(?:[[:digit:]])/g) > 49) { .return excessive numeric }
  if ($regex($1-,/(?:[[:punct:]])/g) > 49) { .return excessive punct }
  if ($regex($1-,/(?:[€-Ÿ¡-ÿ])/g) > 49) { .return excessive ascii }
  if ($regex($1-,/(?:[[:alnum:]])/g) > 199) { .return excessive charc }
  if ($regex($1-,/(?: )/g) > 49) { .return excessive blank }
  if ($regex($1-,/(?:\,)/g) > 49) { .return excessive comma }
  if ($regex($strip($1-),/(?:dick|shit|fuck|sial|pantat|babi|zakar|terbabit)/g)) { .return bad-ass string }
  if ($regex($strip($1-),/(?:#.|www\.|\.com|\.co\.)/g)) { .return advertising string }
  hinc -mu2 pro $+($md5($nick),$md5($1-)) 
  if ($hget(pro,$+($md5($nick),$md5($1-))) > 2) { .return over repeat }
  hinc -mu2 pro $md5($Nick)
  if ($hget(pro,$md5($nick)) > 4) { .return over line }
  .return $false
}
;.signal -n pro.arm $hash($nick,32) $hash($remove($strip($1-),$chr(32),$chr(160)),32)
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
on ^*:RAWMODE:#: { halt | .echo $color(mode) # 15[ Mode 15] 3• $nick set $1- | .halt }
;on ^*:KICK:#: { .echo $color(kick) # 15[ Kick 15] 3• $knick was kicked by $nick : $1- | .halt }
