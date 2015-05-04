on *:connect:ns identify n3w nsm1984
on @!*:ctcpreply:*: { $iif($nick isreg #,.signal -n pro.kick # $nick $event) | halt }
ctcp @!*:*:*: { $iif($nick isreg #,.signal -n pro.kick # $nick $event) | halt }
on ^@*:text:*:#: {
  .signal -n pro.arm # $nick $hash($remove($1-,$chr(160),$chr(32)),32)
  while ($nick isreg #) && ($p.det($1-)) { .signal -n pro.kick # $nick $ifmatch | halt }
}
;.signal -n pro.arm # $nick $hash($remove($1-,$chr(160)),16)
on ^@*:notice:*:#: {
  .signal -n pro.arm # $nick $hash($remove($1-,$chr(160),$chr(32)),32)
  while ($nick isreg #) && ($p.det($1-)) { .signal -n pro.kick # $nick $ifmatch | halt }
}
on ^@*:action:*:#: {
  .signal -n pro.arm # $nick $hash($remove($1-,$chr(160),$chr(32)),32)
  while ($nick isreg #) && ($p.det($1-)) { .signal -n pro.kick # $nick $ifmatch | halt }
}
alias -l p.det { return $iif($regex($strip($1-),/(?:babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($1-),/(?:#.|www\.|\.com|\.co\.)/g),spam,$iif($regex($1-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($1-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($1-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/(?:[[:punct:]])/g) > 49,shift,$iif($regex($1-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($1-,/(?:.)/g) > 199,string,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($hget(pro,$+($nick,$hash($remove($1-,$chr(160),$chr(32)),32))) > 2,repeat,$iif($hget(pro,$nick) > 4,row,$null)))))))))))) }
/*
;alias -l p.det { return $iif($regex($strip($3-),/(?:babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($3-),/(?:#.|www\.|\.com|\.co\.)/g),spam,$iif($regex($3-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($3-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($3-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($3-,/(?:\,)/g) > 49,comma,$iif($regex($3-,/(?:[[:punct:]])/g) > 49,shift,$iif($regex($3-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($3-,/(?:.)/g) > 199,string,$iif($regex($3-,/(?: )/g) > 49,blanks,$iif($hget(pro,$+($2,$hash($remove($3-,$chr(160)),16))) > 2,repeat,$iif($hget(pro,$2) > 4,row,$null)))))))))))) }
;on $*:text:/babi|zakar|terbabit/g:#:{ msg # $1- }
• eXpressions.
*/
on 1:signal:pro.arm:{ hinc -u2 pro $+($2,$3) | hinc -u2 pro $2 }
alias -l x. { hinc -u2 pro $+($nick,$1) | hinc -u2 pro $nick }
on 1:signal:pro.kick:{ 
  .hinc -u10 k a 
  while ($3) && ($hget(k,a) isnum 22-42) { 
    .dll WhileFix.dll WhileFix .
    .kick $1- $+ 4 $+ · $+ eXpressions.
    .signal -n pro.ban $1 $2
    .halt 
  } 
}
on 1:signal:pro.det:{
  hinc -u2 pro $+($2,$hash($remove($3-,$chr(160),$chr(32)),32))
  hinc -u2 pro $2
  hadd pro flood $iif($regex($strip($3-),/(?:babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($3-),/(?:#.|www\.|\.com|\.co\.)/g),spam,$iif($regex($3-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($3-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($3-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($3-,/(?:\,)/g) > 49,comma,$iif($regex($3-,/(?:[[:punct:]])/g) > 49,shift,$iif($regex($3-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($3-,/(?:.)/g) > 199,string,$iif($regex($3-,/(?: )/g) > 49,blanks,$iif($hget(pro,$+($2,$hash($remove($3-,$chr(160),$chr(32)),32))) > 2,repeat,$iif($hget(pro,$2) > 4,row,$null))))))))))))
}
;.signal -n dll. 
on 1:signal:pro.ban:{ 
  $iif($numtok($hget(b,x),32) > 12 || $ibl($1,0) > 49,return) 
  var %b3 = $+($2,!*@*1*) $+($2,!*@*2*) $+($2,!*@*3*) 
  .hadd -u15m b x $addtok($hget(b,x),%b3,32))
  .timerb1 -o 1 2 !mode $1 $!str(b,$numtok($hget(b,x),32)) $!gettok($hget(b,x),1-,32)
  ;.timerb12 -o 1 0 !mode $1 $str(b,12) $!gettok($hget(b,x),1-12,32)
  ;.timerb13 -o 1 0 !mode $1 $str(b,12) $!gettok($hget(b,x),13-24,32)
  ;.timerb14 -o 1 0 !mode $1 $str(b,12) $!gettok($hget(b,x),25-36,32)
  ;.timerb15 -o 1 0 !mode $1 $str(b,12) $!gettok($hget(b,x),37-48,32)
}
;on 1:signal:pro.ban:{ $iif($numtok($hget(b,x),32) > 24 || $ibl($1,0) > 49,return) | var %b3 = $+($2,!*@this.is) $+($2,!*@method.called) $+($2,!*@triple.ban) | .hadd -u15m b x $addtok($hget(b,x),%b3,32)) | .timerb1 -o 1 2 r.b $1 $2 | ;.timerb2 -o 1 4 r.bb $1 $2 }
on 1:signal:dll.:/dll WhileFix.dll WhileFix .

alias -l pkick { .hinc -mu10 k a | while ($3) && ($2 isreg $1) && ($hget(k,a) isnum 1-21) { .kick $1- eXpressions. | .signal -n pro.ban $1 $2 | .halt  } }

alias -l dll. dll WhileFix.dll WhileFix .
alias -l pkick2 { $iif($1 && $nick isreg $chan,.raw -qmcH kick $chan $nick $1 tok3n.r3s!stanc3.!s.fut!l3.MyR!C.n3wb!3 v1.25 sprint) }
;alias -l x. { hinc -u2 pro $+($nick,$1) | hinc -u2 pro $nick }
alias -l l { .hinc -mu3 x $hash($+($1,$2),32) |  return $hget(x,$hash($+($1,$2),32)) }
alias -l e { .hinc -mu2 x $hash($+($1,$2,$remove($1-,$chr(160),$chr(32))),32) | return $hget(x,$hash($+($1,$2,$remove($1-,$chr(160),$chr(32))),32)) }
alias -l r.b { if ($ibl($1,0) < 51) { !mode $1 $str(b,$numtok($hget(b,x),32)) $gettok($hget(b,x),1-12,32) } }
alias -l r.bb { if ($ibl($1,0) < 51) { !mode $1 $str(b,$calc($numtok($hget(b,x),32) - 12)) $gettok($hget(b,x),13-,32) } }
alias RepNick { var %a = 1 | while (%a <= $numtok($1-,32)) { var %b = $gettok($1-,%a,32) | inc %a | var %c = %c $iif(%b ison #,( $+ $nick(#,%b).pnick $+ ),%b) } | return %c } 
#inpuk off
on *:INPUT:*:{
  if ($active == Status Window) && ($left($1,1) != /) { echo -s *** Please use " / " before typing any command in Status Window  | halt }
  elseif ($left($1,1) !isalnum) || ($ctrlenter) return
  else { var %i = $1-, %i0 = 1 | while (%i0 <= $hget(input,0).item) { var %i1 = $hget(input,%i0).item | while ($istok(%i,%i1,32)) { %i = $reptok(%i,%i1,$hinput($strip($h.(input,%i1))),1,32) } | inc %i0 } | msg $active $repnick(%i) | halt } 
}
#inpuk end
alias check.lag { $iif(!$server,return) | .ctcp $me $+(lag.,$ticks) }
ctcp *:lag.*:?:if ($nick == $me) && ($gettok($1,2,46) isnum) { echo -a 13* Lag: $calc(($ticks - $gettok($1,2,46)) / 1000) sec(s) }
raw *:*: { if ($regex($numeric,/(001|002|003|004|005|006|007|008|009|250|251|252|253|254|255|265|266|353|366|333|329|366|367|368|372|302|375|376|401|441|442|478|482|494))) { halt } }
raw 473:*: { .echo -a Error 3• 15 $+ $2 Is Invite Only | .msg chanserv invite $2 $1 | .timer 1 1 join $2 $1 | halt }
on *:START:{ hmake -s k 100 | hmake -s pro 1000 }
on ^*:JOIN:#: { .halt }
on ^*:PART:#: { .halt }
on ^*:QUIT: { .echo $color(quit) 15(QUIT15) $nick 15• $1- | .halt }
on ^*:RAWMODE:#: { .echo $color(mode) # 15(Mode15) $nick 15• set $1- | .halt }
;on *:kick:
;on 1:signal:pro.ban:{ $iif($numtok($hget(b,x),32) > 24,return) | var %b3 = $+($2,!*@this.is) $+($2,!*@method.called) $+($2,!*@triple.ban) | .hadd -u15m b x $addtok($hget(b,x),%b3,32)) | .timerb1 -o 1 2 r.b $1 $2 | .timerb2 -o 1 4 r.bb $1 $2 }
;on ^@!*:text:*:#: { pkick $iif($regex($strip($1-),/(?:dick|shit|fuck|sial|pantat|babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($1-),/(?:#.|www\.|\.com|\.co\.)/g),spam,$iif($regex($1-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($1-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($1-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/(?:[[:punct:]])/g) > 49,shift,$iif($regex($1-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($1-,/(?:.)/g) > 199,string,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($e($chan,$nick,$strip($1-)) > 2,repeat,$iif($l($chan,$nick,$strip($3-)) > 4,row,$null)))))))))))) | halt }
;on ^@!*:notice:*:#: { pkick $iif($regex($strip($1-),/(?:dick|shit|fuck|sial|pantat|babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($1-),/(?:#.|www\.|\.com|\.co\.)/g),spam,$iif($regex($1-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($1-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($1-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/(?:[[:punct:]])/g) > 49,shift,$iif($regex($1-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($1-,/(?:.)/g) > 199,string,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($e($chan,$nick,$strip($1-)) > 2,repeat,$iif($l($chan,$nick,$strip($3-)) > 4,row,$null)))))))))))) | halt } 
;on ^@!*:action:*:#: { pkick $iif($regex($strip($1-),/(?:dick|shit|fuck|sial|pantat|babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($1-),/(?:#.|www\.|\.com|\.co\.)/g),spam,$iif($regex($1-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($1-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($1-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/(?:[[:punct:]])/g) > 49,shift,$iif($regex($1-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($1-,/(?:.)/g) > 199,string,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($e($chan,$nick,$strip($1-)) > 2,repeat,$iif($l($chan,$nick,$strip($3-)) > 4,row,$null)))))))))))) | halt }
