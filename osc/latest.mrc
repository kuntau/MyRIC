on @!*:ctcpreply:*: { while ($nick isreg #) { .hinc -mu5 k a 1 | if ($hget(k,a) isnum %nu) { .raw -qmcH kick # $nick × faulty $+ . $+ $event × %r × | .signal -n pro.ban # $nick } | halt } }
ctcp @!*:*:*: { while ($nick isreg #) { .hinc -mu5 k a 1 | if ($hget(k,a) isnum %nu) { .raw -qmcH kick # $nick × faulty $+ . $+ $event × %r × | .signal -n pro.ban # $nick } | halt } }
on ^@!*:text:*:#: { 
  var %ex $iif($regex($strip($1-),/(?:dick|shit|fuck|sial|pantat|babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($1-),/(?:#.|www\.|\.com|\.co\.)/g),spam,$iif($regex($1-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($1-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($1-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/(?:[[:punct:]])/g) > 49,shift,$iif($regex($1-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($1-,(?:.)g) > 199,string,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($e($chan,$nick,$strip($1-)) > 2,repeat,$iif($l($chan,$nick,$strip($3-)) > 4,row,$null))))))))))))
  while (%ex) && ($nick isreg #) { .hinc -mu5 k a 1 | if ($hget(k,a) isnum %nu) { .raw -qmcH kick # $nick × %ex $+ . $+ $event × %r × | .signal -n pro.ban # $nick } | halt } 
}
on ^@!*:notice:*:#: { 
  var %ex $iif($regex($strip($1-),/(?:dick|shit|fuck|sial|pantat|babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($1-),/(?:#.|www\.|\.com|\.co\.)/g),spam,$iif($regex($1-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($1-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($1-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/(?:[[:punct:]])/g) > 49,shift,$iif($regex($1-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($1-,(?:.)g) > 199,string,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($e($chan,$nick,$strip($1-)) > 2,repeat,$iif($l($chan,$nick,$strip($3-)) > 4,row,$null))))))))))))
  while (%ex) && ($nick isreg #) { .hinc -mu5 k a 1 | if ($hget(k,a) isnum %nu) { .raw -qmcH kick # $nick × %ex $+ . $+ $event × %r × | .signal -n pro.ban # $nick } | halt } 
}
on ^@!*:action:*:#: { 
  var %ex $iif($regex($strip($1-),/(?:dick|shit|fuck|sial|pantat|babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($1-),/(?:#.|www\.|\.com|\.co\.)/g),spam,$iif($regex($1-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($1-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($1-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/(?:[[:punct:]])/g) > 49,shift,$iif($regex($1-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($1-,(?:.)g) > 199,string,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($e($chan,$nick,$strip($1-)) > 2,repeat,$iif($l($chan,$nick,$strip($3-)) > 4,row,$null))))))))))))
  while (%ex) && ($nick isreg #) { .hinc -mu5 k a 1 | if ($hget(k,a) isnum %nu) { .raw -qmcH kick # $nick × %ex $+ . $+ $event × %r × | .signal -n pro.ban # $nick } | halt } 
}
;var %ex $iif($regex($1-,/[[:cntrl:]]/g) > 49,codes,$iif($regex($1-,/[[:upper:]]/g) > 49,caps,$iif($regex($1-,/[[:digit:]]/g) > 49,numerics,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/[[:punct:]]/g) > 49,shift,$iif($regex($1-,/[€-Ÿ|¡-ÿ]/g) > 49,ascii,$iif($regex($1-,/./g) > 199,character,$iif($regex($1-,/(?: )/g) > 49,blanks,$null))))))))
;var %ex $iif($regex($1-,/[[:cntrl:]]/g) > 49,codes,$iif($regex($1-,/[[:upper:]]/g) > 49,caps,$iif($regex($1-,/[[:digit:]]/g) > 49,numerics,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/[[:punct:]]/g) > 49,shift,$iif($regex($1-,/[€-Ÿ|¡-ÿ]/g) > 49,ascii,$iif($regex($1-,/./g) > 199,character,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($hget(x,$hash($+(#,$nick,$remove($hget(x,st),$chr(160),$chr(32))),32)) >= 3,repeats,$iif($hget(x,$hash($+(#,$nick),32)) >= 5,lines,$null)))))))))) 
;$iif($hget(x,lt) == adv,$ü(inviter),$iif($hget(x,lt) == bad,$ü(swear),$iif($regex($hget(x,at),/[[:cntrl:]]/g) >= 50,$ü(codes),$iif($regex($hget(x,st),/[[:upper:]]/g) >= 50,$ü(caps),$iif($regex($hget(x,st),/[[:digit:]]/g) >= 50,$ü(numerics),$iif($regex($hget(x,st),/[ $+ $chr(44) $+ ]/g) >= 50,$ü(aphostropes),$iif($regex($hget(x,st),/[[:punct:]]/g) >= 50,$ü(shift),$iif($regex($hget(x,st),/[€-Ÿ|¡-ÿ]/g) >= 50,$ü(asciis),$iif($regex($hget(x,st),/./g) >= 200,$ü(characters),$iif($regex($hget(x,st),/[ $+ $chr(160) $+ ]/g) >= 50,$ü(blanks),$iif($hget(x,$hash($+(#,$nick,$remove($hget(x,st),$chr(160),$chr(32))),32)) >= 3,$ü(repeats),$iif($hget(x,$hash($+(#,$nick),32)) >= 5,$ü(lines),goto echo))))))))))))
alias -l l { .hinc -mu3 x $hash($+($1,$2),32) |  return $hget(x,$hash($+($1,$2),32)) }
alias -l e { .hinc -mu2 x $hash($+($1,$2,$remove($1-,$chr(160),$chr(32))),32) | return $hget(x,$hash($+($1,$2,$remove($1-,$chr(160),$chr(32))),32)) }
on 1:signal:pro.ban:{
  .hadd -u15m b x $addtok($hget(b,x),$+($2,!*@n3w.MyRiC),32)) 
  .timerb1 1 4 r.b $1 $2
  .timerb2 1 10 r.bb $1 $2
}
alias -l r.b { if ($ibl($1,0) < 51) { !mode $1 $str(b,$numtok($hget(b,x),32)) $gettok($hget(b,x),1-12,32) } }
alias -l r.bb { if ($ibl($1,0) < 51) { !mode $1 $str(b,$calc($numtok($hget(b,x),32) - 12)) $gettok($hget(b,x),13-,32) } }
;<Dk> alias -l b { .hinc -mu2 v w | if ($ibl($1,0) > 49) { halt } | else { if ($hget(v,w) < 13) { .set -u2 %b $addtok(%b,$address($2,8),32)) |  .timerx $+ $1 1 2 !mode $1 $str(b,12) %b } } }
on 1:signal:pro.arm:{ hinc -mu2 pro $+($1,$2-) | hinc -mu2 pro $1 }
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
on ^*:QUIT: { .echo $color(quit) 15(QUIT15) $nick 15• $1- | .halt }
on ^*:RAWMODE:#: { .echo $color(mode) # 15(Mode15) $nick 15• set $1- | .halt }
;on ^*:KICK:#: { .echo $color(kick) # 15(Kick15) $nick kick $knick 15• ( $+ $1- $+ ) | .halt }
