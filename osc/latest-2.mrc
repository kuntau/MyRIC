on *:connect:ns identify K|ck nsm1984
on @!*:ctcpreply:*: { while ($nick isreg #) { .hinc -mu5 k a 1 | if ($hget(k,a) isnum %nu) { $a.($event) } | halt } }
ctcp @!*:*:*: { while ($nick isreg #) { .hinc -mu5 k a 1 | if ($hget(k,a) isnum %nu) { $a.($event) } | halt } }
on ^@!*:text:*:#: { 
  hadd -m g x $iif($regex($strip($1-),/(?:dick|shit|fuck|sial|pantat|babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($1-),/(?:#.|www\.|\.com|\.co\.)/g),spam,$iif($regex($1-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($1-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($1-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/(?:[[:punct:]])/g) > 49,shift,$iif($regex($1-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($1-,/(?:.)/g) > 199,string,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($e($chan,$nick,$strip($1-)) > 2,repeat,$iif($l($chan,$nick,$strip($3-)) > 4,row,$null))))))))))))
  while ($hget(g,x)) && ($nick isreg #) { .hinc -mu5 k a 1 | if ($hget(k,a) isnum %nu) { $a.($hget(g,x)) } | halt }
}
on ^@!*:notice:*:#: { 
  hadd -m g x $iif($regex($strip($1-),/(?:dick|shit|fuck|sial|pantat|babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($1-),/(?:#.|www\.|\.com|\.co\.)/g),spam,$iif($regex($1-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($1-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($1-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/(?:[[:punct:]])/g) > 49,shift,$iif($regex($1-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($1-,/(?:.)/g) > 199,string,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($e($chan,$nick,$strip($1-)) > 2,repeat,$iif($l($chan,$nick,$strip($3-)) > 4,row,$null))))))))))))
  while ($hget(g,x)) && ($nick isreg #) { .hinc -mu5 k a 1 | if ($hget(k,a) isnum %nu) { $a.($hget(g,x)) } | halt }
}
on ^@!*:action:*:#: { 
  hadd -m g x $iif($regex($strip($1-),/(?:dick|shit|fuck|sial|pantat|babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($1-),/(?:#.|www\.|\.com|\.co\.)/g),spam,$iif($regex($1-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($1-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($1-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/(?:[[:punct:]])/g) > 49,shift,$iif($regex($1-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($1-,/(?:.)/g) > 199,string,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($e($chan,$nick,$strip($1-)) > 2,repeat,$iif($l($chan,$nick,$strip($3-)) > 4,row,$null))))))))))))
  while ($hget(g,x)) && ($nick isreg #) { .hinc -mu5 k a 1 | if ($hget(k,a) isnum %nu) { $a.($hget(g,x)) } | halt }
}
on 1:signal:pro.ban:{ $iif($numtok($hget(b,x),32) > 24,return) | var %b3 = $+($2,!*@this.is) $+($2,!*@method.called) $+($2,!*@triple.ban) | .hadd -u15m b x $addtok($hget(b,x),%b3,32)) | .timerb1 -o 1 2 r.b $1 $2 | .timerb2 -o 1 4 r.bb $1 $2 }
on 1:signal:pro.arm:{ hinc -mu2 pro $+($1,$2-) | hinc -mu2 pro $1 }
alias -l a- return $iif($regex($strip($1-),/(?:dick|shit|fuck|sial|pantat|babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($1-),/(?:#.|www\.|\.com|\.co\.)/g),spam,$iif($regex($1-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($1-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($1-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/(?:[[:punct:]])/g) > 49,shift,$iif($regex($1-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($1-,/(?:.)/g) > 199,string,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($e($chan,$nick,$strip($1-)) > 2,repeat,$iif($l($chan,$nick,$strip($3-)) > 4,row,$null))))))))))))
alias -l a. { .raw -qmcH kick # $nick 15,15 14,14 15,1 $1 14,14 15,15 14,14 14,1 resistance.is.futile 14,14 15,15 14,14 15,1 MyRIC.n3wbi3 14,14 15,15  | .signal -n pro.ban # $nick }
;var %ex $iif($regex($strip($1-),/(?:dick|shit|fuck|sial|pantat|babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($1-),/(?:#.|www\.|\.com|\.co\.)/g),spam,$iif($regex($1-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($1-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($1-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/(?:[[:punct:]])/g) > 49,shift,$iif($regex($1-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($1-,/(?:.)/g) > 199,string,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($e($chan,$nick,$strip($1-)) > 2,repeat,$iif($l($chan,$nick,$strip($3-)) > 4,row,$null))))))))))))
;while ($hget(g,x)) && ($nick isreg #) { .hinc -mu5 k a 1 | if ($hget(k,a) isnum %nu) { .raw -qmcH kick # $nick × $hget(g,x) $+ . $+ $event × %r × | .signal -n pro.ban # $nick } | halt } 
alias -l l { .hinc -mu3 x $hash($+($1,$2),32) |  return $hget(x,$hash($+($1,$2),32)) }
alias -l e { .hinc -mu2 x $hash($+($1,$2,$remove($1-,$chr(160),$chr(32))),32) | return $hget(x,$hash($+($1,$2,$remove($1-,$chr(160),$chr(32))),32)) }
alias -l r.b { if ($ibl($1,0) < 51) { !mode $1 $str(b,$numtok($hget(b,x),32)) $gettok($hget(b,x),1-12,32) } }
alias -l r.bb { if ($ibl($1,0) < 51) { !mode $1 $str(b,$calc($numtok($hget(b,x),32) - 12)) $gettok($hget(b,x),13-,32) } }
alias RepNick { var %a = 1 | while (%a <= $numtok($1-,32)) { var %b = $gettok($1-,%a,32) | inc %a | var %c = %c $iif(%b ison #,( $+ $nick(#,%b).pnick $+ ),%b) } | return %c } 
#inpuk on
on *:INPUT:*:{
  if ($active == Status Window) && ($left($1,1) != /) { echo -s *** Please use " / " before typing any command in Status Window  | halt }
  elseif ($left($1,1) !isalnum) || ($ctrlenter) return
  else { var %i = $1-, %i0 = 1 | while (%i0 <= $hget(input,0).item) { var %i1 = $hget(input,%i0).item | while ($istok(%i,%i1,32)) { %i = $reptok(%i,%i1,$hinput($strip($h.(input,%i1))),1,32) } | inc %i0 } | msg $active $repnick(%i) | halt } 
}
raw *:*: { if ($regex($numeric,/(001|002|003|004|005|006|007|008|009|250|251|252|253|254|255|265|266|353|366|333|329|366|367|368|372|302|375|376|401|441|442|478|482|494))) { halt } }
on ^*:JOIN:#: { .halt }
on ^*:PART:#: { .halt }
on ^*:QUIT: { .echo $color(quit) 15(QUIT15) $nick 15• $1- | .halt }
on ^*:RAWMODE:#: { .echo $color(mode) # 15(Mode15) $nick 15• set $1- | .halt }
;on *:kick:
