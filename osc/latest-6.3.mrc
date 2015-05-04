on *:connect:ns identify n3w nsm1984
on !*:ctcpreply:*: { while ($nick isreg #) { .k $event | halt } }
ctcp !*:*:*: { while ($nick isreg #) { .k $event | halt } }
on ^*:text:*:#: { 
  hinc -u5 pro $nick
  hinc -u5 pro $+($nick,$md5($remove($strip($1-),$chr(160),$chr(32)))) 
  while ($nick isreg #) && ($iif($regex($strip($1-),/(?:babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($1-),/(?:#.|www\.|\.com)/g),spam-ass,$iif($regex($1-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($1-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($1-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/(?:[[:punct:]])/g) > 49,punct,$iif($regex($1-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($1-,/(?:.)/g) > 199,string,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($hget(pro,$+($nick,$md5($remove($1-,$chr(160),$chr(32))))) > 2,repeat,$iif($hget(pro,$nick) > 4,row,$null))))))))))))) { .k $ifmatch | halt } 
}
on ^*:notice:*:#: { 
  hinc -u5 pro $nick
  hinc -u5 pro $+($nick,$md5($remove($strip($1-),$chr(160),$chr(32)))) 
  while ($nick isreg #) && ($iif($regex($strip($1-),/(?:babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($1-),/(?:#.|www\.|\.com)/g),spam-ass,$iif($regex($1-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($1-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($1-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/(?:[[:punct:]])/g) > 49,punct,$iif($regex($1-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($1-,/(?:.)/g) > 199,string,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($hget(pro,$+($nick,$md5($remove($1-,$chr(160),$chr(32))))) > 2,repeat,$iif($hget(pro,$nick) > 4,row,$null))))))))))))) { .k $ifmatch | halt } 
}
on ^*:action:*:#: { 
  hinc -u5 pro $nick
  hinc -u5 pro $+($nick,$md5($remove($strip($1-),$chr(160),$chr(32)))) 
  while ($nick isreg #) && ($iif($regex($strip($1-),/(?:babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($1-),/(?:#.|www\.|\.com)/g),spam-ass,$iif($regex($1-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($1-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($1-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/(?:[[:punct:]])/g) > 49,punct,$iif($regex($1-,/(?:[€-Ÿ|¡-ÿ])/g) > 49,ascii,$iif($regex($1-,/(?:.)/g) > 199,string,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($hget(pro,$+($nick,$md5($remove($1-,$chr(160),$chr(32))))) > 2,repeat,$iif($hget(pro,$nick) > 4,row,$null))))))))))))) { .k $ifmatch | halt } 
}
alias -l .k... {
  .hinc -u10 k a 
  $iif($hget(k,a) !isnum 43-63,return)
  .sockwrite -tn myric kick $chan $nick 15 int main(int $1 $+ , char * $+ $1 $+ [ $+ $ifmatch $+ +]) 15 $+ %hack2 $+  %o 
  .signal -n sock.ban $chan $nick
}
alias -l .k.. {
  $iif($hget(k,a) > 20,.return,.hinc -u10 k a)
  .sockwrite -tn myric kick $chan $nick 15 int main(int $1 $+ , char * $+ $1 $+ [ $+ $ifmatch $+ +]) 15 $+ %hack2 $+  %o
  .signal -n sock.ban $chan $nick
}
alias -l .k {
  $iif($hget(k,a) > 41,.return,.hinc -u10 k a)
  $iif($hget(k,a) > 21,.sockwrite -tn myric) kick $chan $nick 15 int main(int $1 $+ , char * $+ $1 $+ [ $+ $ifmatch $+ +]) 15 $+ %hack2 $+  15The13.15e13X15pression13.15v7 
  .signal -n $iif($hget(k,a) > 21,sock.ban,pro.ban) $chan $nick
}
;$iif($hget(k,a) > 41,.halt,.hinc -u10 k a) | $iif($ifmatch > 21,.sockwrite -tn myric) kick $chan $nick 14 $+ $1 $+ 14e13X14pressionv7
alias -l .k.. {
  $iif($hget(k,a) > 20 || !$1,halt,.hinc -u10 k a)
  .dll WhileFix.dll WhileFix .
  .kick $chan $nick $1 $+ 4 $+ · $+ eXpressions v7
  .signal -n pro.ban $chan $nick
  .halt 
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
  var %b3 = $+($2,!.1.@^_-) $+($2,!.2.@-_^) $+($2,!.3.@^_^) 
  $iif($numtok($hget(b,x),32) < 25 && $ibl($1,0) < 51,.hadd -u15m b x $addtok($hget(b,x),%b3,32)),return)
  .timerb1 -o 1 2 !mode $1 $!str(b,$numtok($hget(b,x),32)) $!gettok($hget(b,x),1-12,32)
  ;.timerb2 -o 1 4 !mode $1 $str(b,12) $!gettok($hget(b,x),13-24,32)
}
on 1:signal:sock.ban:{ 
  var %s3 = $+($2,!.1.@^_-) $+($2,!.2.@-_^) $+($2,!.3.@^_^) 
  $iif($numtok($hget(s,x),32) < 25 && $ibl($1,0) < 50,.hadd -u15m s x $addtok($hget(s,x),%s3,32)),return)
  .timerbs1 -om 1 1500 sockwrite -tn myric mode $1 $!str(b,$numtok($hget(s,x),32)) $!gettok($hget(s,x),1-12,32)
  ;.timerbs2 -o 1 4 sockwrite -tn myric mode $1 $str(b,12) $!gettok($hget(s,x),13-24,32)
}
on 1:signal:super.ban:{
  var %b3 = $str($s.ban ,50)
  $iif($numtok($hget(b,x),32) < 50,.hadd -u15m b x $addtok($hget(b,x),%b3,32)))
}
alias b. { timerzzxc 1 1 echo -a $!str($eval($s.ban,50) }
alias s.ban return $+($r(A,Z),$r(a,z),$r(a,z),$r(0,9),$r(0,9),$r(0,9),*!*@*)
on 1:signal:dll.:/dll WhileFix.dll WhileFix .
alias RepNick { var %a = 1 | while (%a <= $numtok($1-,32)) { var %b = $gettok($1-,%a,32) | inc %a | var %c = %c $iif(%b ison #,( $+ $nick(#,%b).pnick $+ ),%b) } | return %c } 
#inpuk off
on *:INPUT:#:{
  ;if ($active == Status Window) && ($left($1,1) != /) { echo -s *** Please use " / " before typing any command in Status Window  | halt }
  $iif($left($1,1) == $chr(47) || ($ctrlenter),return)
  ;else { var %i = $1-, %i0 = 1 | while (%i0 <= $hget(input,0).item) { var %i1 = $hget(input,%i0).item | while ($istok(%i,%i1,32)) { %i = $reptok(%i,%i1,$hinput($strip($h.(input,%i1))),1,32) } | inc %i0 } | msg $active $repnick(%i) | halt } 
  ;sockwrite -tn myric privmsg $active $eval($1- ,2)
  say $replace($1-,l,1,e,3,t,7,a,4,o,0,s,5,$chr(32),$chr(46)) $+ .
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
on ^*:RAWMODE:#: { .echo $color(mode) # * 15(Mode15) $nick 15• set $1- | .halt }
