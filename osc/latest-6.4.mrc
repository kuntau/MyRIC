on *:connect:ns identify n3w nsm1984
on @!*:ctcpreply:*: { $iif($nick isreg #,$.k($event)) | halt }
ctcp @!*:*:*: { $iif($nick isreg #,$.k($event)) | halt }
on ^@*:text:*:#: { 
  while ($nick isreg #) { $.k.($1-) | halt } 
}
on ^@*:notice:*:#: { 
  .signal -n pro.arm # $nick $md5($remove($1-,$chr(160),$chr(32)))
  while ($nick isreg #) && ($iif($regex($strip($1-),/(?:babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($1-),/(?:#.|www\.|\.com)/g),spam-ass,$iif($regex($1-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($1-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($1-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/(?:[[:punct:]])/g) > 49,punct,$iif($regex($1-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($1-,/(?:.)/g) > 199,string,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($hget(pro,$+($nick,$md5($remove($1-,$chr(160),$chr(32))))) > 2,repeat,$iif($hget(pro,$nick) > 4,row,$null))))))))))))) { $.k($ifmatch) | halt } 
}
on ^@*:action:*:#: { 
  .signal -n pro.arm # $nick $md5($remove($1-,$chr(160),$chr(32)))
  while ($nick isreg #) && ($iif($regex($strip($1-),/(?:babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($1-),/(?:#.|www\.|\.com)/g),spam-ass,$iif($regex($1-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($1-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($1-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/(?:[[:punct:]])/g) > 49,punct,$iif($regex($1-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($1-,/(?:.)/g) > 199,string,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($hget(pro,$+($nick,$md5($remove($1-,$chr(160),$chr(32))))) > 2,repeat,$iif($hget(pro,$nick) > 4,row,$null))))))))))))) { $.k($ifmatch) | halt } 
}
alias -l .k {
  .hinc -u10 k a 
  while ($1) && ($hget(k,a) isnum 22-42) { 
    .dll WhileFix.dll WhileFix .
    .scon -a kick $chan $nick $1 $+ 4 $+ · $+ eXpressions v6.3
    .signal -n pro.ban $chan $nick
    .halt 
  } 
}
alias -l .k. {
  .signal -n pro.arm # $nick $md5($remove($1-,$chr(160),$chr(32)))
  ;echo -a 4ToST
  while (((!$hget(k,a)) || ($hget(k,a) < 22)) && ($iif($regex($strip($1-),/(?:babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($1-),/(?:#.|www\.|\.com)/g),spam-ass,$iif($regex($1-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($1-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($1-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/(?:[[:punct:]])/g) > 49,punct,$iif($regex($1-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($1-,/(?:.)/g) > 199,string,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($hget(pro,$+($nick,$md5($remove($1-,$chr(160),$chr(32))))) > 2,repeat,$iif($hget(pro,$nick) > 4,row,$null))))))))))))) { 
    echo -a 4TEST
    .hinc -u10 k a 
    ; && ($iif($regex($strip($1-),/(?:babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($1-),/(?:#.|www\.|\.com)/g),spam-ass,$iif($regex($1-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($1-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($1-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/(?:[[:punct:]])/g) > 49,punct,$iif($regex($1-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($1-,/(?:.)/g) > 199,string,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($hget(pro,$+($nick,$md5($remove($1-,$chr(160),$chr(32))))) > 2,repeat,$iif($hget(pro,$nick) > 4,row,$null)))))))))))))
    .dll WhileFix.dll WhileFix .
    .kick $chan $nick $ifmatch $+ 4 $+ · $+ eXpressions v6.3
    .signal -n pro.ban $chan $nick
    .halt 
  } 
}
/*
;alias -l p.det { return $iif($regex($strip($3-),/(?:babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($3-),/(?:#.|www\.|\.com|\.co\.)/g),spam,$iif($regex($3-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($3-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($3-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($3-,/(?:\,)/g) > 49,comma,$iif($regex($3-,/(?:[[:punct:]])/g) > 49,shift,$iif($regex($3-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($3-,/(?:.)/g) > 199,string,$iif($regex($3-,/(?: )/g) > 49,blanks,$iif($hget(pro,$+($2,$hash($remove($3-,$chr(160)),16))) > 2,repeat,$iif($hget(pro,$2) > 4,row,$null)))))))))))) }
;on $*:text:/babi|zakar|terbabit/g:#:{ msg # $1- }
• eXpressions.
;.timerb12 -o 1 0 !mode $1 $str(b,12) $!gettok($hget(b,x),1-12,32)
;.timerb13 -o 1 0 !mode $1 $str(b,12) $!gettok($hget(b,x),13-24,32)
;.timerb14 -o 1 0 !mode $1 $str(b,12) $!gettok($hget(b,x),25-36,32)
;.timerb15 -o 1 0 !mode $1 $str(b,12) $!gettok($hget(b,x),37-48,32)
;.signal -n dll. 
*/
on 1:signal:pro.arm:{ hinc -u2 pro $+($2,$3) | hinc -u2 pro $2 }
on 1:signal:pro.ban:{ 
  $iif($numtok($hget(b,x),32) > 12 || $ibl($1,0) > 49,return) 
  var %b3 = $+($2,!.1.@^_-) $+($2,!.2.@-_^) $+($2,!.3.@^_^) 
  .hadd -u15m b x $addtok($hget(b,x),%b3,32))
  .timerb1 -o 1 2 !mode $1 $!str(b,$numtok($hget(b,x),32)) $!gettok($hget(b,x),1-12,32)
  ;.timerb2 -o 1 5 !mode $1 $str(b,12) $!gettok($hget(b,x),13-24,32)
}
on 1:signal:dll.:/dll WhileFix.dll WhileFix .
alias RepNick { var %a = 1 | while (%a <= $numtok($1-,32)) { var %b = $gettok($1-,%a,32) | inc %a | var %c = %c $iif(%b ison #,( $+ $nick(#,%b).pnick $+ ),%b) } | return %c } 
#inpuk off
on *:INPUT:*:{
  ;if ($active == Status Window) && ($left($1,1) != /) { echo -s *** Please use " / " before typing any command in Status Window  | halt }
  $iif($left($1,1) == $chr(47) || ($ctrlenter),return)
  ;else { var %i = $1-, %i0 = 1 | while (%i0 <= $hget(input,0).item) { var %i1 = $hget(input,%i0).item | while ($istok(%i,%i1,32)) { %i = $reptok(%i,%i1,$hinput($strip($h.(input,%i1))),1,32) } | inc %i0 } | msg $active $repnick(%i) | halt } 
  sockwrite -tn myric privmsg $active $eval($1- ,2)
  halt 
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
