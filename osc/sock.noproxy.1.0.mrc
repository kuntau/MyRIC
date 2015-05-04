on *:deop:#:{ if ($opnick == MyRIC) { ns.priv # !op | mode # +o MyRIC } }
on ^*:unban:#: { halt }
on ^*:ban:#: { halt }
on ^*:join:#: { if ($nick == MyRIC && $me isop #) { mode # +o MyRIC } }
on ^*:text:*:#: { if ($nick isreg $chan) { halt } }
on ^*:notice:*:#: { if ($nick isreg $chan) { halt } }
on ^*:action:*:#: { if ($nick isreg $chan) { halt } }
raw *:*: { if ($regex($numeric,/(001|002|003|004|005|006|007|008|009|250|251|252|253|254|255|265|266|353|366|333|329|366|367|368|372|302|375|376|401|441|442|478|482|494))) { halt } }
raw 473:*: { .echo -a Error 3? 15 $+ $2 Is Invite Only | .msg chanserv invite $2 $1 | .timer 1 1 join $2 $1 | halt }
;on *:connect: { .timerping 0 30 F12 | F4 }
on 1:connect:{
  window -h @dxz | .debug -ipt @dxz dxz | window -h @dxz
  if ($server == nexus.banjirian.net) { .ns identify Kuntau nsx | .away AuToRuN BoT By KuNTaU [ - c l a s s - ] | halt }
}


;test sock proxy
alias nS.open { $iif(!$sock(myric).status,sockopen power $server $port,return) | .timer.nSock 1 1 nS.logo Status: $!sock(power).status }
alias nS.close { $iif($sock(myric).status,sockwrite -tn myric quit You are temporarily banned from this network. Excessive Flooding,return) | .timer.nSock 1 1 nS.logo Status: $iif(!$sock(myric).status,inactive) }
alias nS.join $iif($sock(myric).status,.sockwrite -tn myric join $1)
alias nS.part $iif($sock(myric).status,.sockwrite -tn myric part $1)
alias nS.priv $iif($sock(myric).status,.sockwrite -tn myric privmsg $1 $eval($2-,2))
alias nS.nick $iif($sock(myric).status,.sockwrite -tn myric nick $1)
alias nS.logo .echo $color(info) -a * 15(12n4So8ck15) 15• $1-

on !*:ctcpreply:*: { while ($nick isreg $chan) { kc # $nick cliente a la contestación del protocolo del cliente | return } }
ctcp !*:*:*: { while ($nick isreg $chan) { kc # $nick cliente al protocolo del cliente | return } }
on 1:signal:pro.arm:{
  ;hadd -mu2 pro nick  
  hinc -mu2 pro $+($1,$2-) 
  hinc -mu2 pro $1 
}
ON 1:SOCKOPEN:power: {
  if ($sockerr) return
  .sockwrite -tn $sockname NICK %s.nick
  .sockwrite -tn $sockname USER l337. $+ $r(0,9) $+ $r(0,9) $r(a,z) $r(a,z) : $+ 15La13.15e13X15presión13.15v8 Build: 1727 edición española
  .timersssssssssssss 1 1 sockrename $sockname myric

  ;.sockwrite -tn $sockname CONNECT $server $+ : $+ $port $+(HTTP/1.0,$CRLF,$CRLF)
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
  /sockread %s.read
  if ($gettok(%s.read,1,32) == PING) { sockwrite -tn $sockname $replace(%s.read,PING,PONG) | halt }
  $iif($gettok(%s.read,2,32) !isin NOTICE PRIVMSG,halt)
  .tokenize 58 %s.read
  var %s.chan = $gettok(%s.read,3,32), %s.nix = $gettok($gettok(%s.read,1,58),1,33)
  if (%s.nix isreg %s.chan) { 
    if ($regex($2-,/(?:|||)/g) > 49) { kc %s.chan %s.nix códigos de control }
    if ($regex($strip($2-),/(?:#.)/g)) { kc %s.chan %s.nix anuncie }
    if ($regex($strip($2-),/(?:babi)/g)) { kc %s.chan %s.nix maldición }
    if ($regex($2-,/(?:[A-Z])/g) > 49) { kc %s.chan %s.nix casquillos }
    if ($regex($2-,/(?:[0-9])/g) > 49) { kc %s.chan %s.nix numéricos }
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

alias -l kc {
  $iif(%kx > 20,return)
  .sockwrite -tn myric kick $1- %logo %kx
  .signal -n sock.ban $1-
  .inc -u10 %kx
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
on *:CLOSE:@x*:{ .debug -i NUL dxz  }
alias dxz {
  if ($regex($1, /^<- :([^!]*)![^@]*@[^ ]*\s*PRIVMSG\s*(\S*)\s*:\001\s*DCC\s*(SEND|RESUME).*"(?:[^" ]*\s){32}.*$/i)) { 
    kc $regml(2) $regml(1) dcc exploit
    return
  }
}
