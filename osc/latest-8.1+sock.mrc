alias saham {
  var %saham = $2-, %saham.count = 1
  while (%saham.count <= $numtok(%saham,32)) {
    say !labur $gettok(%saham,%saham.count,32) $1
    inc %saham.count
  }
}
alias kuda {
  var %kuda = $2-, %kuda.count = 1
  while (%kuda.count <= $numtok(%kuda,32)) {
    say !kuda $gettok(%kuda,%kuda.count,32) $1
    inc %kuda.count
  }
}
alias jackpot {
  //.timerjackpot 3 0 //say !jackpot $!r(1,50)
}
;on *:JOIN:#:{ kill $nick lancau flooder kejap yer user yg betul lancau ni bikin panas }
on !*:ctcpreply:*: {
  while ($nick isreg $chan) {
    ;kc # $nick cliente a la contestación del protocolo del cliente
    -k $event
    halt 
  } 
}
ctcp !*:*:*: { 
  while ($nick isreg $chan) {
    ;kc # $nick cliente al protocolo del cliente | return
    -k $event 
    halt 
  } 
}
alias -l kc {
  $iif(%kx > 20,return)
  .sockwrite -tn myric kick $1- $+ : pruebe el modo ... 15La13.15e13X15presión13.15v8 12G4ò8ó12g3l4e™ edición. 
  .signal -n sock.ban $1-
  .inc -u10 %kx
}
;on ^@*:text:*:#: { if ($nick isreg $chan) && ($:d($1-)) { -k $ifmatch | halt } }
;on ^@*:notice:*:#: { if ($nick isreg $chan) && ($:d($1-)) { -k $ifmatch | halt } }
;on ^@*:action:*:#: { if ($nick isreg $chan) && ($:d($1-)) { -k $ifmatch | halt } }
alias -l -kzzz {
  ;halt
  .hinc -mu10 kick range 
  $iif($hget(kick,range) !isnum 22-42,return)
  .kick $chan $nick 15 int main(int $1 $+ , char * $+ $1 $+ [ $+ $ifmatch $+ +]) 04 $+ http://www.friendster.com/profiles/kuntau $+  %o $+ 
  .signal -n pro.ban $chan $nick
}
alias -l -kz { kick $chan $nick $1 }
alias -l -k {
  .inc -u10 %1 1
  if (%1 isnum 1-21) {
    .scon -a kick $chan $nick $1- $+ .
    .set -u2 %kci. %kci. $nick $+ 100101001000111
    .timeraa 1 1 .mode $chan + $+ $str(b,12) %kci.
  }
}
alias -l -k2 {
  $iif($hget(k,a) > 20,.return,.hinc -u10 k a)
  .sockwrite -tn myric kick $chan $nick 15 int main(int $1 $+ , char * $+ $1 $+ [ $+ $ifmatch $+ +]) 15 $+ %hack2 $+  %o 
  .signal -n sock.ban $chan $nick
}
alias -l -k:: {
  .hinc -u10 k a 
  if ($hget(k,a) isnum 1-42) {
    $iif($ifmatch isnum 1-21,.sockwrite -tn myric) kick $chan $nick 15 int main(int $1 $+ , char * $+ $1 $+ [ $+ $ifmatch $+ +]) 15 $+ %hack2 $+  %o $+ 
    .signal -n $iif($ifmatch isnum 1-21,sock.ban,pro.ban) $chan $nick
    .return 
  }
  .return 
}
alias -l .k.. {
  .hinc -u10 k a 
  if ($hget(k,a) isnum 22-42) { .sockwrite -tn myric kick $chan $nick 15 int main(int $1 $+ , char * $+ $1 $+ [ $+ $ifmatch $+ +]) 15 $+ %hack2 $+  %o  | .signal -n sock.ban $chan $nick }
  if ($hget(k,a) isnum 43-63) { .scon -a kick $chan $nick 15 int main(int $1 $+ , char * $+ $1 $+ [ $+ $ifmatch $+ +]) 15 $+ %hack2 $+  %o  | .signal -n pro.ban $chan $nick }
  .return 
}
alias -l .k.. { return }
alias -l :d2 {
  .hinc -mu5 pro2 $nick
  .hinc -mu5 pro2 $+($nick,$md5($remove($strip($1-),$chr(160),$chr(32))))
  .return $iif($regex($strip($1-),/(?:babi)/g),bad-ass,$iif($regex($strip($1-),/(?:#.|www\.|\.com)/g),spam-ass,$iif($regex($1-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($1-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($1-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($1-,/(?:\,)/g) > 49,comma,$iif($regex($1-,/(?:[[:punct:]])/g) > 49,punct,$iif($regex($1-,/(?:[?-?|¡-ÿ])/g) > 49,ascii,$iif($regex($1-,/(?:.)/g) > 199,string,$iif($regex($1-,/(?: )/g) > 49,blanks,$iif($hget(pro2,$+($nick,$md5($remove($1-,$chr(160),$chr(32))))) > 2,repeat,$iif($hget(pro2,$nick) > 4,row,$null))))))))))))
}
alias -l :d {
  if ($regex($1-,/(?:|||)/g) > 49) { .return cntrl }
  if ($regex($strip($1-),/(?:#.)/g)) { .return anuncie }
  if ($regex($strip($1-),/(?:babi)/g)) { .return maldición }
  if ($regex($1-,/(?:[[:upper:]])/g) > 49) { .return casquillos }
  if ($regex($1-,/(?:[[:digit:]])/g) > 49) { .return numéricos }
  if ($regex($1-,/(?:\,)/g) > 49) { .return comas }
  if ($regex($1-,/(?:[[:punct:]])/g) > 49) { .return cambios }
  if ($regex($1-,/(?: )/g) > 49) { .return espacios en blanco }
  if ($regex($1-,/(?:[€-Ÿ¡-ÿ])/g) > 49) { .return asciis }
  if ($regex($1-,/(?:[[:alnum:]])/g) > 199) { .return longitudes }
  var %t2 = $hash($remove($1-,$chr(32),$chr(160)),32)
  .signal -n pro.arm2 $nick %t2
  if ($hget(pro2,$+($nick,%t2)) > 2) { .return repetidor }
  if ($hget(pro2,$nick) > 4) { .return líneas }
  .return $null
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
;alias -l p.det { return $iif($regex($strip($3-),/(?:babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($3-),/(?:#.|www\.|\.com|\.co\.)/g),spam,$iif($regex($3-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($3-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($3-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($3-,/(?:\,)/g) > 49,comma,$iif($regex($3-,/(?:[[:punct:]])/g) > 49,shift,$iif($regex($3-,/(?:[?-?|¡-ÿ])/g) > 49,ascii,$iif($regex($3-,/(?:.)/g) > 199,string,$iif($regex($3-,/(?: )/g) > 49,blanks,$iif($hget(pro,$+($2,$hash($remove($3-,$chr(160)),16))) > 2,repeat,$iif($hget(pro,$2) > 4,row,$null)))))))))))) }
;on $*:text:/babi|zakar|terbabit/g:#:{ msg # $1- }
? eXpressions.
;.timerb12 -o 1 0 !mode $1 $str(b,12) $!gettok($hget(b,x),1-12,32)
;.timerb13 -o 1 0 !mode $1 $str(b,12) $!gettok($hget(b,x),13-24,32)
;.timerb14 -o 1 0 !mode $1 $str(b,12) $!gettok($hget(b,x),25-36,32)
;.timerb15 -o 1 0 !mode $1 $str(b,12) $!gettok($hget(b,x),37-48,32)
;.signal -n dll. 
*/
on 1:signal:pro.arm:{ hinc -u2 pro $+($2,$3) | hinc -u2 pro $2 }
on 1:signal:pro.arm2:{ hinc -u2 pro2 $+($2,$3) | hinc -u2 pro2 $2 }
on 1:signal:pro.ban:{ 
  var %b3 = $+($2,!.1.@1011001100) $+($2,!.2.@00100010011) $+($2,!.3.@110010101) 
  $iif($numtok($hget(b,x),32) < 25 && $ibl($1,0) < 450,.hadd -u15m b x $addtok($hget(b,x),%b3,32)),return)
  .timerb1 -o 1 2 !mode $1 $!str(b,$numtok($hget(b,x),32)) $!gettok($hget(b,x),1-12,32)
  ;.timerb2 -o 1 4 !mode $1 $str(b,12) $!gettok($hget(b,x),13-24,32)
  ;if ($numtok($hget(b,x),32) > 11) {
  ;e testtt $numtok($hget(b,x),32)
  ;mode $1 + $+ $str(b,12) $gettok($hget(b,x),1-,32)
  ;hfree b
  ;}
}
on 1:signal:sock.ban:{ 
  var %s3 = $+($2,!.1.@^_-) $+($2,!.2.@-_^) $+($2,!.3.@^_^) 
  $iif($numtok($hget(s,x),32) < 25 && $ibl($1,0) < 50,.hadd -u15m s x $addtok($hget(s,x),%s3,32)),return)
  .timerbs1 -om 1 2000 sockwrite -tn myric mode $1 $!str(b,$numtok($hget(s,x),32)) $!gettok($hget(s,x),1-12,32)
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
alias leet { echo -a $replace($1-,l,1,e,3,t,7,a,4,o,0,s,5) | halt }
;alias check.lag { $iif(!$server,return) | .ctcp $me $+(lag.,$ticks) }
;ctcp *:lag.*:?:if ($nick == $me) && ($gettok($1,2,46) isnum) { echo -a 13* Lag: $calc(($ticks - $gettok($1,2,46)) / 1000) sec(s) }
raw *:*: { if ($regex($numeric,/(001|002|003|004|005|006|007|008|009|250|251|252|253|254|255|265|266|353|366|333|329|366|367|368|372|302|375|376|401|441|442|478|482|494))) { halt } }
raw 473:*: { .echo -a Error 3? 15 $+ $2 Is Invite Only | .msg chanserv invite $2 $1 | .timer 1 1 join $2 $1 | halt }
on *:START:{ hmake -s k 100 | hmake -s pro 1000 }
on ^*:JOIN:#: { .halt }
on ^*:PART:#: { .halt }
;on ^*:unban:#: { .halt }
