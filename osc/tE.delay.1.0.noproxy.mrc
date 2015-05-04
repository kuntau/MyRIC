on *:deop:#:{ if ($opnick == MyRIC) { ns.priv # !op | mode # +o MyRIC } }
on *:connect: { .timerping 0 300 F12 | join #flood | msg birc op #flood 123456 | ns.open }
on *:quit: { if ($nick == myric) ns.open }

;test sock proxy 210.0.209.108
alias nS.open { $iif(!$sock(myric).status,sockopen power $server $port,return) | .timer.nSock 1 1 nS.logo Status ::: power: $iif(!$sock(power).status,inactive) myric: $iif(!$sock(myric).status,inactive) }
;alias nS.close { $iif($sock(myric).status,sockwrite -tn myric quit You are temporarily banned from this network. Excessive Flooding,return) | .timer.nSock 1 1 nS.logo Status: $iif(!$sock(power).status,inactive) }
alias nS.close { $iif($sock(myric).status,sockwrite -tn myric quit Pi makan sat,return) | .timer.nSock 1 1 nS.logo Status: $iif(!$sock(power).status,inactive) }
alias nS.join $iif($sock(myric).status,.sockwrite -tn myric join $1)
alias nS.part $iif($sock(myric).status,.sockwrite -tn myric part $1)
alias nS.priv $iif($sock(myric).status,.sockwrite -tn myric privmsg $1 $eval($2-,2))
alias nS.nick $iif($sock(myric).status,.sockwrite -tn myric nick $1)
alias nS.reboot { nS.close | nS.open }
alias nS.checkbot { 
  if (!$sock(myric).status) { nS.open }
  elseif (%s.nick !ison $1) { .sockwrite -tn myric join $1 }
}
alias nS.logo .echo $color(info) -a * 15(12n4So8ck15) 15 $1-

;on !*:ctcpreply:*: { while ($nick isreg $chan) { kc # $nick cliente a la contestación del protocolo del cliente | return } }
;ctcp !*:*:*: { while ($nick isreg $chan) { kc # $nick cliente al protocolo del cliente | return } }
on 1:signal:pro.arm:{
  ;hadd -mu2 pro nick  
  hinc -mu2 pro $+($1,$2-) 
  hinc -mu2 pro $1 
}
ON 1:SOCKOPEN:power: {
  if ($sockerr)  { return }
  .sockwrite -tn $sockname NICK %s.nick
  .sockwrite -tn $sockname USER l337. $+ $r(0,9) $+ $r(0,9) $r(a,z) $r(a,z) : $+ 15The13.15e13X15pression13.15v11 Mastering Edition.
  .sockrename $sockname myric
}
ON *:SOCKREAD:power:{
  .sockread %s.read
  if ($gettok(%s.read,1,32) == PING) { sockwrite -tn $sockname PONG : $gettok(%s.read,2,58) | return }
  var %s.raw = $gettok(%s.read,2,32), %s.chan = $gettok(%s.read,3,32), %s.nix = $gettok($gettok(%s.read,1,58),1,33), %s.$1- = $gettok(%s.read,2,58)

  unset %s.read 
}
ON *:SOCKWRITE:myric:{
  if ($sockerr > 0) { echo -a error on sockwrite: $sock($sockname).wserr | return }
  ;echo -a 9send queue: $sock($sockname).sq
}
ON *:SOCKREAD:myric:{
  .sockread %s.read
  if ($gettok(%s.read,2,32) == 376) { sockwrite -tn $sockname join #banjir | halt }
  if ($gettok(%s.read,1,32) == PING) { sockwrite -tn $sockname $replace(%s.read,PING,PONG) | halt }
  halt
  ;remove halt above
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
    if ($regex($2-,/(?:[-¡-ÿ])/g) > 49) { kc %s.chan %s.nix asciis }
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
on *:START:{ hmake -s flood 100 | hload -s flood osc/hflood.dll | hmake -s k 100 | hmake -s pro 1000 | window -e @notice }

alias -l kc {
  .hinc -mu5 k a 1
  if ($hget(k,a) < 21) {
    .sockwrite -tn myric kick $1- testing mode... 15The13.15e13X15pression13.15v8 12G4ò8ó12g3l4e version. 
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
;if ($2 == 376) { .sockwrite -tn slayer.* join %sock.chan | .echo 4 -a ***[[-SOCK ONLINE-]] }
ON *:NOTIFY:{ $iif($nick ison #,halt) | echo @notice $event ::: $nick = %s.nick | nS.join #flood }
ON *:UNOTIFY:{ ns.open }

menu menubar,channel {
  -
  sockclose !!: { $iif($sock(myric).status,sockclose myric,halt) }
  $iif($sock(myric).status,Quit Sock ( active ),Open Sock ( inactive )) :{
    $iif(!$sock(myric).status,nS.open,nS.close)
  }
  $iif($sock(myric).status,Reboot Sock ( active ),Reboot Sock ( inactive )) :{
    nS.reboot
  }
  -
  $iif(!$sock(myric).status,$style(2)) $iif(%s.nick !ison #,Join Counter ( $active ),Part Counter ( $active )) :{ 
    if (%s.nick ison #) { nS.part # | halt }
    nS.join # 
  }
  Change Counter Nick ( %s.nick ) : {
    var %nS.x = $$?="Please put new sock counter nick"
    $iif(%nS.x,set %s.nick $ifmatch,halt)
    $iif($sock(myric).status,nS.nick %nS.x)
  }
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
