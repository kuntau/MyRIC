/*
- sock counter v2.1 by Kuntau
- hehe this addon release for 1st time. dont know usefull for you or not
- function: as name... socket counter for banjirian !!!
- info: no dialog box just popup. i think very easy to use. 
- any problem or bug report i can be reach at kuntau@swbell.net
- copyright Kuntau 22.07.2005 5 a.m
- version 2.1 : enable/disable counter, add some error checking, privmsg sock, and some minor change in coding
*/

on 1:sockopen:myric:{
  $iif($sockerr,return)
  .sockwrite -tn $sockname user MyRIC 2 3 : eXpressions. Counter
  .nS.nick $iif(%nS.nick,$ifmatch,$+(MyRIC[count,$r(00,99),]))
  .timer.sc.away 1 5 .sockwrite -tn $sockname away $nS.adv
  .halt
}
on 1:sockread:myric:{ 
  if ($sockerr) return 
  $iif(!%s.re,sockread %s.re,sockread %s.re)
  if (!$sockbr) return 
  if ($mid(%s.re,1,4) == PING) { .sockwrite -tn $sockname PONG $remove($remove(%s.re,ping :),ping) | halt } 
  var %c = $gettok(%s.re,3,32), %n = $gettok($gettok(%s.re,1,58),1,33), %m = $gettok(%s.re,2,32), %x = $strip($gettok(%s.re,4,32))
  $iif(!%nS.on,halt,$iif(%m == MODE && b isincs %x && $left(%x,1) == $chr(43),.signal -n sc.ban %c %n %x,$iif(%m == KICK,.signal -n sc.kick %c %n,halt)))
}

on ^@*:text:*:#: { if ($nick isreg $chan) { halt } }
on ^@*:notice:*:#: { if ($nick isreg $chan) { halt } }
on ^@*:action:*:#: { if ($nick isreg $chan) { halt } }
on ^@*:join:#: { halt }
alias nS.open { $iif(!$sock(myric).status,sockopen myric $server $port,halt) | .timer.nSock 1 1 nS.logo Status: $!sock(myric).status }
alias nS.close { $iif($sock(myric).status,sockclose myric,halt) | .timer.nSock 1 1 nS.logo Status: $iif(!$sock(myric).status,inactive) }
alias nS.join { if ($sock(myric).status) { .sockwrite -tn myric join $1 | .timer.nSock 1 2  nS.priv # !voice } }
alias nS.part $iif($sock(myric).status,.sockwrite -tn myric part $1)
alias nS.priv $iif($sock(myric).status,.sockwrite -tn myric privmsg $1 $eval($2-,2))
alias nS.nick $iif($sock(myric).status,.sockwrite -tn myric nick $1)
alias nS.logo .echo $color(info) -a * 15(12n4So8ck15) 15• $1-
;alias nS.adv return Get your own copy of Socket counter addon at: 4http://www.geocities.com/teamkuntau/sock.counter.v2.1.zip zip password: 4zxc eXpressions. 
alias nS.adv return 6• 7MOTD 6• Kuntau handsome
alias nS.out .return 6• 7COUNTER 6• $2 6• 4KICK 6• $iif($hget(kick,$2),$ifmatch,$null) 6• 12BAN 6• $iif($hget(ban,$2),$ifmatch,$null) 6•

alias nS.out2 {
  set %+c 13|6•13|6
  set %+top 13KICK6 & 13BAN RESULT
  set %+mid 13ROUND STATISTICS
  set %+bot 13END OF STATISTICS
  set %+len 80
  ;echo -a %+c $+ $str( ,30) $+ %+top $+ $str( ,30) $+ %+c
  echo -a %+c $+ $nS.InitOut(%+top) $+ %+c

  echo -a %+c $+ $nS.InitOut(6Result for 13Kuntau6 for this round: 13216 Kicks & 13126 Bans6) $+ %+c
  ;echo -a %+c $str( ,5) 6Result for 13Kuntau6 for this round: 13216 Kicks & 13126 Bans6 $str( ,5) %+c

  echo -a %+c $+ $nS.InitOut(%+mid) $+ %+c
  echo -a %+c $str( ,5) 13KICK/BAN RESULT6 $str( ,5) %+c
  echo -a %+c $+ $nS.InitOut(%+bot) $+ %+c
  ;.return 6• 7COUNTER 6• $2 6• 4KICK 6• $iif($hget(kick,$2),$ifmatch,$null) 6• 12BAN 6• $iif($hget(ban,$2),$ifmatch,$null) 6•
}
alias nS.outx3 {
  set %+c 13|6•13|6
  set %+top 13KICK6 & 13BAN RESULT
  set %+mid 13ROUND STATISTICS
  set %+bot 13END OF STATISTICS
  set %+len 80
  ;echo -a %+c $+ $str( ,30) $+ %+top $+ $str( ,30) $+ %+c
  echo -a %+c $+ $nS.InitOut(%+top) $+ %+c

  echo -a %+c $+ $nS.InitOut(6Result 13Kuntau6 for this round: 13216 Kicks & 13126 Bans6) $+ %+c
  ;echo -a %+c $str( ,5) 6Result for 13Kuntau6 for this round: 13216 Kicks & 13126 Bans6 $str( ,5) %+c

  echo -a %+c $+ $nS.InitOut(%+mid) $+ %+c
  echo -a %+c $+ $nS.InitOut(6Total clone kicked:13 99) $+ %+c
  echo -a %+c $+ $nS.InitOut(%+bot) $+ %+c
  ;.return $2 kick $iif($hget(kick,$2),$ifmatch,$null) ban $iif($hget(ban,$2),$ifmatch,$null)
}
alias nS.out3 {
  var %+kick = $hget(kick,0).item
  var %+ban = $hget(ban,0).item
  var %+total = $iif(%+kick > %+ban,%+kick,%+ban)
  var %+count = 1
  ;e %+kick --> %+ban ---> %+total
  echo -a %+c $+ $nS.InitOut(%+top) $+ %+c
  while (%+count <= %+total) {
    var %+fhash = $hget(kick,%+count).item
    var %+fresult = 06Result 13 $+ %+fhash $+ 06 for this round are 13 $+ $hget(kick,%+fhash) $+ 06 kick(s) & 13 $+ $hget(ban,%+fhash) 06Ban(s).
    echo -a %+c $+ $nS.InitOut(%+fresult) $+ %+c
    inc %+count
  }
  echo -a %+c $+ $nS.InitOut(%+mid) $+ %+c
  echo -a %+c $+ $nS.InitOut(6Total of 13 $+ $hget(total,kick) $+ 6 kicks and 13 $+ $hget(total,kick) $+ 6bans made for this round) $+ %+c
  echo -a %+c $+ $nS.InitOut(%+bot) $+ %+c
  hfree ban
  hfree kick
  hfree total
}
alias nS.InitOut {
  var %+striped = $strip($1-)
  var %+lened = $len(%+striped)
  var %+calced = $calc(100 - %+lened)
  var %+dived = $calc(%+calced / 2)
  ;echo -a ::: %+lened --> %+calced ---> %+dived
  return $str( ,%+dived) $+ $1- $+ $str( ,%+dived) $+ $iif($chr(46) isin %+dived, )
}
;13|6•13|

;using separate signal coz lazy... make sure not clash with ur own signal event
on *:signal:sc.ban: { 
  .hinc -m ban $2 $count($3,b) 
  .hadd -m total ban $calc($hget(total,ban) + $count($3,b))
  .hinc -m nick $2
  .timer $+ $1 1 15 ns.out3
  ;.timerlove $+ $1 -o 1 15 nS.priv $1 $nS.adv
}
on *:signal:sc.kick: { 
  .hinc -m kick $2
  .hinc -m total kick 
  .hinc -m nick $2
  .timer $+ $1 1 15 ns.out3
}

on *:signal:sc.banx: { .hinc -mu30 ban $2 $count($3,b) | .timer $+ $1 $+ $2 -o 1 12 nS.priv $1 $nS.out($1,$2) | .timerlove $+ $1 -o 1 15 nS.priv $1 $nS.adv }
on *:signal:sc.kickx: { .hinc -mu30 kick $2 | .timer $+ $1 $+ $2 -o 1 12 nS.priv $1 $nS.out($1,$2) }

;always dc if chatting while kicking ? on this input and your sock bot will talk for you. nice eh
;escape key for normal text is ctrl + enter in-case you dont know
#sock.in off
on *:INPUT:*:{
  if ($active == Status Window) && ($left($1,1) != /) { nS.logo Please use " / " before typing " $1- " or any command in Status Window  | halt }
  $iif($left($1,1) == $chr(47) || ($ctrlenter) || !$sock(myric).status,return)
  nS.priv $active $repnick($1-)
  halt 
}
#sock.in end
on *:load: { nS.logo Sock counter v2.1 loaded !!! | var %nS.x = $$?="Please put new sock counter nick" | set %nS.nick $iif(%nS.x,$ifmatch,$+(MyRIC[count,$r(00,99),])) | set %nS.on $true }
on *:unload: { nS.logo Sock counter v2.1 unloaded !!! | unset %nS.nick %nS.on }

;menu... nothing to explain LOL
menu menubar,channel {
  -
  $iif($sock(myric).status,Sockclose ( Active ),Sockopen ( Inactive )) :{ $iif(!$sock(myric).status,nS.open,nS.close) }
  -
  $iif(!$sock(myric).status,,$iif(%nS.nick !ison #,Join Counter ( $active ),Part Counter ( $active ))) :{ $iif(%nS.nick ison #,nS.part #,nS.join #) | nS.logo Status: $iif(%nS.nick ison #,Parting #,Joining #) }
  Sock Nick ( %nS.nick ) : { var %nS.x = $$?="Please put new sock counter nick" | $iif(%nS.x,set %nS.nick $ifmatch,halt) | nS.logo New sock nick: %nS.nick | $iif($sock(myric).status,nS.nick %nS.x) }
  Sock Input ( $iif($group(#sock.in).status == on,Enable,Disable) ) : { $iif($group(#sock.in).status == on,.disable #sock.in,.enable #sock.in) | nS.logo Sock input: $iif($ifmatch != on,Enabled,Disabled) }
  Sock Counter ( $iif(%nS.on,Enable,Disable) ) : { set %nS.on $iif(%nS.on,$false,$true) | nS.logo Sock counter: $iif(!$ifmatch,Enabled,Disabled) }
}

/*
p.s: dont complain this remote bad coded or can be shorten or anything like that. i write this in 5 minutes ._. nobody perfect LOL
*/
