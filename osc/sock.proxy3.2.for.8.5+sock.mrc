on *:deop:#:{ if ($opnick == MyRIC) { ns.priv # !op | mode # +o MyRIC } }
on ^*:unban:#: { halt }
on ^*:ban:#: { halt }
;on *:connect: { .timerping 0 30 F12 | F4 }

;test sock proxy
alias nS.open { $iif(!$sock(myric).status,sockopen power 210.0.209.108 3128,return) | .timer.nSock 1 1 nS.logo Status: $!sock(power).status }
alias nS.close { $iif($sock(myric).status,sockwrite -tn myric quit You are temporarily banned from this network. Excessive Flooding,return) | .timer.nSock 1 1 nS.logo Status: $iif(!$sock(myric).status,inactive) }
alias nS.join $iif($sock(myric).status,.sockwrite -tn myric join $1)
alias nS.part $iif($sock(myric).status,.sockwrite -tn myric part $1)
alias nS.priv $iif($sock(myric).status,.sockwrite -tn myric privmsg $1 $eval($2-,2))
alias nS.nick $iif($sock(myric).status,.sockwrite -tn myric nick $1)
alias nS.logo .echo $color(info) -a * 15(12n4So8ck15) 15• $1-
;61.108.41.2 3128
;210.95.17.253 3128
;210.0.209.108 3128
;61.108.96.122 3128
;202.129.12.18 8080
;219.93.21.25:8080
;/firewall on 211.252.175.65 3128
;/firewall on 220.65.55.19 8080
;/firewall on 219.93.174.108 80
;61.108.54.129 8080
;125.248.137.58
;125.250.28.138
;211.43.205.125 1081

;on !*:ctcpreply:*: { while ($nick isreg $chan) { kc # $nick cliente a la contestación del protocolo del cliente | return } }
;ctcp !*:*:*: { while ($nick isreg $chan) { kc # $nick cliente al protocolo del cliente | return } }
on 1:signal:pro.arm:{
  ;hadd -mu2 pro nick  
  hinc -mu2 pro $+($1,$2-) 
  hinc -mu2 pro $1 
}
ON 1:SOCKOPEN:power: {
  if ($sockerr)  { return }
  .sockwrite -tn $sockname CONNECT $server $+ : $+ $port $+(HTTP/1.0,$CRLF,$CRLF)
}
ON *:SOCKREAD:power:{
  .sockread %s.read
  if ($gettok(%s.read,1,32) == PING) { sockwrite -tn $sockname PONG : $gettok(%s.read,2,58) | return }
  var %s.raw = $gettok(%s.read,2,32), %s.chan = $gettok(%s.read,3,32), %s.nix = $gettok($gettok(%s.read,1,58),1,33), %s.$1- = $gettok(%s.read,2,58)
  ;if (!$regex(%s.raw,/(200|PRIVMSG|NOTICE)/)) || (kantoi isin %:reason) { return }

  if ($gettok(%s.read,1-2,32) == HTTP/1.0 200) || ($gettok(%s.read,1-2,32) == HTTP/1.1 200) {
    .sockwrite -tn $sockname NICK %s.nick
    .sockwrite -tn $sockname USER l337. $+ $r(0,9) $+ $r(0,9) $r(a,z) $r(a,z) : $+ 15La13.15e13X15presión13.15v8 Build: 1727 edición española
    .timersssssssssssss 1 5 sockrename $sockname myric
    ;.timer.s.away 1 3 sockwrite -tn $sockname away 14134rn 70 r34d15;14 r34d 70 134rn15;
  }
  unset %s.read 
}
ON *:SOCKREAD:myric:{
  .sockread %s.read
  ;.dll WhileFix.dll WhileFix .
  if ($gettok(%s.read,1,32) == PING) { sockwrite -tn $sockname $replace(%s.read,PING,PONG) | halt }
  $iif($gettok(%s.read,2,32) !isin NOTICE PRIVMSG,halt)
  .tokenize 58 %s.read
  var %s.chan = $gettok(%s.read,3,32), %s.nix = $gettok($gettok(%s.read,1,58),1,33)
  if (%s.nix isreg %s.chan) { 
    if ($regex($2-,/(?:|||)/g) > 49) { kc %s.chan %s.nix códigos de control }
    if ($regex($strip($2-),/(?:#.)/g)) { kc %s.chan %s.nix anuncie }
    if ($regex($strip($2-),/(?:babi)/g)) { kc %s.chan %s.nix maldición }
    if ($regex($2-,/(?:[[:upper:]])/g) > 49) { kc %s.chan %s.nix casquillos }
    if ($regex($2-,/(?:[[:digit:]])/g) > 49) { kc %s.chan %s.nix numéricos }
    if ($regex($2-,/(?:\,)/g) > 49) { kc %s.chan %s.nix comas }
    if ($regex($2-,/(?:[[:punct:]])/g) > 49) { kc %s.chan %s.nix cambios }
    if ($regex($2-,/(?: )/g) > 49) { kc %s.chan %s.nix espacios en blanco }
    if ($regex($2-,/(?:[€-Ÿ¡-ÿ])/g) > 49) { kc %s.chan %s.nix asciis }
    if ($regex($iif($left($2-,1) == $chr(1),$3-,$2-),/(?:[[:lower:]])/g) > 199) { kc %s.chan %s.nix longitudes }
    var %t = $hash($remove($1-,$chr(32),$chr(160)),32)
    .signal -n pro.arm %s.nix %t
    if ($hget(pro,$+(%s.nix,%t)) = 3) { kc %s.chan %s.nix repetidor }
    if ($hget(pro,%s.nix) = 5) { kc %s.chan %s.nix líneas }
    halt
  } 
  unset %s.read
  halt 
}
on *:START:{ hmake -s flood 100 | hload -s flood osc/hflood.dll | hmake -s k 100 | hmake -s pro 1000 }
alias -l s:det {
  .hinc -u5 pro $2
  .hinc -u5 pro $+($2,$md5($remove($strip($3-),$chr(160),$chr(32))))
  .return $iif($regex($strip($3-),/(?:babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($3-),/(?:#.|www\.|\.com)/g),spam-ass,$iif($regex($3-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($3-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($3-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($3-,/(?:\,)/g) > 49,comma,$iif($regex($3-,/(?:[[:punct:]])/g) > 49,punct,$iif($regex($3-,/(?:[?-?|¡-ÿ])/g) > 49,ascii,$iif($regex($3-,/(?:.)/g) > 199,string,$iif($regex($3-,/(?: )/g) > 49,blanks,$iif($hget(pro,$+($2,$md5($remove($3-,$chr(160),$chr(32))))) > 2,repeat,$iif($hget(pro,$2) > 4,row,$null))))))))))))
}
alias -l kcx {
  .hinc -mu10 k a 
  if ($hget(k,a) isnum 1-42) {
    $iif($ifmatch isnum 1-21,.sockwrite -tn myric) kick $1 $2 15 int main(int $3 $+ , char * $+ $3 $+ [ $+ $ifmatch $+ +]) 15 $+ %hack2 $+  %o $+ 
    .signal -n $iif($ifmatch isnum 1-21,sock.ban,pro.ban) $1-
    .return 
  }
  .return 
}
alias -l .k.. {
  .hinc -mu10 k a 
  if ($hget(k,a) isnum 22-42) { .sockwrite -tn myric kick $chan $nick 15 int main(int $1 $+ , char * $+ $1 $+ [ $+ $ifmatch $+ +]) 15 $+ %hack2 $+  %o  | .signal -n sock.ban $chan $nick }
  if ($hget(k,a) isnum 43-63) { .scon -a kick $chan $nick 15 int main(int $1 $+ , char * $+ $1 $+ [ $+ $ifmatch $+ +]) 15 $+ %hack2 $+  %o  | .signal -n pro.ban $chan $nick }
  .return 
}
alias -l kc; { 
  .hinc -u10 k a 
  $iif($hget(k,a) !isnum 1-21,return)
  .sockwrite -tn myric kick $1- testing mode... 15The13.15e13X15pression13.15v8 12G4o8o12g3l4e™ version.
  .signal -n sock.ban $1-2
}
;testing mode... 15The13.15e13X15pression13.15v8 12G4o8o12g3l4e™ version. 
alias -l kc5 { 
  .sockwrite -tn myric kick $1- testing mode ... 12G4o8o12g3l4e™ 
}
alias -l kc {
  $iif(%kx > 20,return)
  .sockwrite -tn myric kick $1- $+ : pruebe el modo ... 15La13.15e13X15presión13.15v8 12G4ò8ó12g3l4e™ edición. 
  .signal -n sock.ban $1-
  .inc -u10 %kx
}
alias -l kcr {
  $iif(%kx > 20 || !$1,return)
  .kick # $nick 0,13 $1- este golpeador estupendo está en la prueba. 
  ;.signal -n sock.ban $1-
  .inc -u10 %kx
}
alias -l kc111 {
  .hinc -mu5 k a 1
  if ($hget(k,a) isnum 42-62) {
    .sockwrite -tn myric kick $1- testing mode... 15The13.15e13X15pression13.15v8 12G4ò8ó12g3l4e™ version. 
    .signal -n sock.ban # $nick
  }
}
on 1:signal:sock.ban:{ 
  var %s3 = $+($2,!.1.@*)
  .hadd -u15m s x $addtok($hget(s,x),%s3,32))
  .timerbs1 1 2 sockwrite -tn myric mode $1 $str(b,12) $gettok($hget(s,x),1-12,32)
  ;.timerbs2 -o 1 4 sockwrite -tn myric mode $1 $str(b,12) $!gettok($hget(s,x),13-24,32)
}
;ON 1:SOCKCLOSE:myric:{ nS.open }
ON *:NOTIFY:{ $iif($nick ison #,halt) | echo -a $event ::: $nick = %s.nick | timer 1 3 nS.join #flood | timer 1 3  nS.priv #flood !op }
ON *:UNOTIFY:{ .timer.s.open 1 1 ns.open }
menu menubar,channel {
  -
  sockclose !!: { $iif($sock(myric).status,sockclose myric,halt) }
  $iif($sock(myric).status,Close Counter ( active ),Open Counter ( inactive )) :{
    $iif(!$sock(myric).status,nS.open,nS.close)
  }
  -
  $iif(!$sock(myric).status,$style(2)) $iif(%s.nick !ison #,Join Counter ( $active ),Part Counter ( $active )) :{ 
    if (%s.nick ison #) { nS.part # | halt }
    nS.join # 
    .timer.nSock 1 2  nS.priv # !op
  }
  Change Counter Nick ( %s.nick ) : {
    var %nS.x = $$?="Please put new sock counter nick"
    $iif(%nS.x,set %s.nick $ifmatch,halt)
    $iif($sock(myric).status,nS.nick %nS.x)
  }
  Change MyRIC[clear] { rlevel 25 | hfree w x | ns.priv # revenge cleared !! | nS.nick MyRIC[clear] }
  Change MyRIC { ns.priv # ready to take any challange now :) | nS.nick MyRIC }
  Sock Input ( $iif($group(#sock.in).status == on,Enable,Disable) ) : { $iif($group(#sock.in).status == on,.disable #sock.in,.enable #sock.in) }
  Sock Counter ( $iif(%nS.on,Enable,Disable) ) : { set %nS.on $iif(%nS.on,$false,$true) }
}
menu nicklist {
  Sock menu
  .Op/DeOp: sockwrite -tn myric mode # $iif($$1 isop #,-,+) $+ $str(o,12) $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12
  .Voice/DeVoice: sockwrite -tn myric mode # $iif($$1 isvo #,-,+) $+ $str(v,12) $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12
  .-
  .Huarghhhhhh:/sockwrite -tn myric kick # $$* Huarghhhhhh... Ptuih!!~ Lag cam Aram cam Sakai !!!
}
