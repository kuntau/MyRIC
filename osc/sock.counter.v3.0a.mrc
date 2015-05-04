/*
- Sock Counter v3.0a by Kuntau
- function: as name... socket counter for banjirian team !!!
- info: no dialog box just popup. i think very easy to use. 
- any problem or bug report i can be reach at kuntau17@gmail.com
- copyright Kuntau 14.05.2006 11 a.m
- version 2.1 (First public release) [22.07.2005] : enable/disable counter, add some error checking, privmsg sock, and some minor change in coding
- version 3.0a [14.05.2006] : over 90% rebuild, improve coding for better understanding, major change in alias name & signal to prevent conflict
*/

on 1:sockopen:nsmSC.SockCounter:{
  $iif($sockerr,return)
  .sockwrite -tn $sockname user MyRIC. $+ $r(10,99) 2 3 : 15La13.15e13X15presión13.15v3.0a edición contraria del zócalo.
  .set %+nsmSC.CounterNick $iif(%nS.nick,$ifmatch,$+(MyRIC[Counter,$r(00,99),]))
  .nsmSC.SockNick %+nsmSC.CounterNick
  .timer.nsmSC.away 1 5 .sockwrite -tn $sockname away $nS.adv
  .halt
}
on 1:sockread:nsmSC.SockCounter:{ 
  if ($sockerr) { return }
  $iif(!%+nsmSC.SockRead,sockread %+nsmSC.SockRead,sockread %+nsmSC.SockRead)
  if (!$sockbr) { return }
  if ($mid(%+nsmSC.SockRead,1,4) == PING) { .sockwrite -tn $sockname PONG $remove($remove(%+nsmSC.SockRead,ping :),ping) | halt } 
  var %+nsmSC.C = $gettok(%+nsmSC.SockRead,3,32), %+nsmSC.n = $gettok($gettok(%+nsmSC.SockRead,1,58),1,33), %+nsmSC.m = $gettok(%+nsmSC.SockRead,2,32), %+nsmSC.x = $strip($gettok(%+nsmSC.SockRead,4,32))
  $iif(!%+nsmSC.OffCounter,halt,$iif(%+nsmSC.m == MODE && b isincs %+nsmSC.x && $left(%+nsmSC.x,1) == $chr(43),.signal -n nsmSC.Ban %+nsmSC.c %+nsmSC.n %+nsmSC.x,$iif(%+nsmSC.m == KICK,.signal -n nsmSC.Kick %+nsmSC.c %+nsmSC.n,halt)))
  .return
}

on ^@*:text:*:#: { if ($nick isreg $chan) { halt } }
on ^@*:notice:*:#: { if ($nick isreg $chan) { halt } }
on ^@*:action:*:#: { if ($nick isreg $chan) { halt } }
on ^@*:join:#: { halt }

alias nsmSC.SockOpen { $iif(!$sock(nsmSC.SockCounter).status,sockopen nsmSC.SockCounter $server $port,halt) | .timernsmSC.Sock 1 1 nsmSC.SockEcho Status: $!sock(nsmSC.SockCounter).status }
alias nsmSC.SockClose { $iif($sock(nsmSC.SockCounter).status,sockclose nsmSC.SockCounter,halt) | .timernsmSC.Sock 1 1 nsmSC.Echo Status: $iif(!$sock(nsmSC.SockCounter).status,inactive) }
alias nsmSC.SockJoin { if ($sock(nsmSC.SockCounter).status) { .sockwrite -tn nsmSC.SockCounter join $1 | .timernscSC.Sock 1 2  nsmSC.SockPriv # !voice } }
alias nsmSC.SockPart $iif($sock(nsmSC.SockCounter).status,.sockwrite -tn nsmSC.SockCounter part $1)
alias nsmSC.SockPriv $iif($sock(nsmSC.SockCounter).status,.sockwrite -tn nsmSC.SockCounter privmsg $1 $eval($2-,2))
alias nsmSC.SockNick $iif($sock(nsmSC.SockCounter).status,.sockwrite -tn nsmSC.SockCounter nick $1)
alias nsmSC.SockEcho .echo $color(info) -a * $nsmSC.SockLogo 13• $1-
alias nsmSC.SockLogo return 13@06nsm`13S06ock13C06ounter
;alias nS.adv return Get your own copy of Socket counter addon at: 4http://www.geocities.com/teamkuntau/sock.counter.v2.1.zip zip password: 4zxc eXpressions. 
alias nsmSC.SockAdv return 13S6ock 13C6ounter 13v3.0a 6by 13Kuntau *6will be release soon13*

alias nS.out3 {
  var %+kick = $hget(kick,0).item
  var %+ban = $hget(ban,0).item
  var %+total = $iif(%+kick > %+ban,%+kick,%+ban)
  var %+count = 1
  ;e %+kick --> %+ban ---> %+total
  echo -a %+c $+ $nS.InitOut(6- 13KICK6 & 13BAN RESULT6 -) $+ %+c
  while (%+count <= %+total) {
    var %+fhash = $hget(kick,%+count).item
    var %+fresult = 06Result 13 $+ %+fhash $+ 06 for this round are 13 $+ $hget(kick,%+fhash) $+ 06 kick(s) & 13 $+ $hget(ban,%+fhash) 06Ban(s).
    echo -a %+c $+ $nS.InitOut(%+fresult) $+ %+c
    inc %+count
  }
  echo -a %+c $+ $nS.InitOut(6- 13ROUND STATISTIC6 -) $+ %+c
  echo -a %+c $+ $nS.InitOut(6First person kick is 13 $+ $hget(total,fkick) $+ 6 & first person ban is 13 $+ $hget(total,fban) $+ 6 .) $+ %+c
  echo -a %+c $+ $nS.InitOut(6Total of 13 $+ $hget(total,kick) $+ 6 kicks & 13 $+ $hget(total,ban) $+ 6 bans been made by 13 $+ $hget(nick,0).item $+ 6 user(s).) $+ %+c
  echo -a %+c $+ $nS.InitOut(06- 13Message Of The Day6 -) $+ %+c
  echo -a %+c $+ $nS.InitOut(13Socket Counter v3.0a6 by 13Kuntau) $+ %+c
  echo -a %+c $+ $nS.InitOut(06This result best viewed using font 13FixedSys6 with size 139) $+ %+c
  echo -a %+c $+ $nS.InitOut(6- 13END OF SCRIPT6 -) $+ %+c
  hfree ban
  hfree kick
  hfree total
  hfree nick
}
alias nS.InitOut {
  var %+striped = $strip($1-)
  var %+lened = $len(%+striped)
  var %+calced = $calc(100 - %+lened)
  var %+dived = $calc(%+calced / 2)
  ;echo -a ::: %+lened --> %+calced ---> %+dived
  return $str( ,%+dived) $+ $1- $+ $str( ,%+dived) $+ $iif($chr(46) isin %+dived, )
}
alias nsmSC.PhaseInit {
  var %+nsmSC.ActTotal = $hget(nsmSC.ActTotal,0).item, %+nsmSC.ActCount = 1
  nsmSC.SockPriv #kuntau %+c $+ $nsmSC.PhaseGenerate(6- 13KICK6 & 13BAN RESULT6 -) $+ %+c
  while (%+nsmSC.ActCount <= %+nsmSC.ActTotal) {
    var %+nsmSC.ActNick = $hget(nsmSC.ActTotal,%+nsmSC.ActCount).item
    var %+nsmSC.KickTotal = $nsmSC.PhaseKick(%+nsmSC.ActNick)
    var %+nsmSC.BanTotal = $nsmSC.PhaseBan(%+nsmSC.ActNick)
    var %+nsmSC.ActResult = 06Result 13 $+ %+nsmSC.ActNick $+ 06 for this round are %+nsmSC.KickTotal & %+nsmSC.BanTotal $+ .
    nsmSC.SockPriv #kuntau %+c $+ $nsmSC.PhaseGenerate(%+nsmSC.ActResult) $+ %+c
    inc %+nsmSC.ActCount
  }
  nsmSC.SockPriv #kuntau %+c $+ $nsmSC.PhaseGenerate(6- 13ROUND STATISTIC6 -) $+ %+c
  nsmSC.SockPriv #kuntau %+c $+ $nsmSC.PhaseGenerate(6First person kick is 13 $+ $hget(nsmSC.General,FirstKick) $+ 6 & first person ban is 13 $+ $hget(nsmSC.General,FirstBan) $+ 6 .) $+ %+c
  nsmSC.SockPriv #kuntau %+c $+ $nsmSC.PhaseGenerate(6Total of 13 $+ $hget(nsmSC.General,kicked) $+ 6 kicks & 13 $+ $hget(nsmSC.General,baned) $+ 6 bans been made by 13 $+ $hget(nsmSC.ActTotal,0).item $+ 6 user(s).) $+ %+c
  nsmSC.SockPriv #kuntau %+c $+ $nsmSC.PhaseGenerate(06- 13Message Of The Day6 -) $+ %+c
  nsmSC.SockPriv #kuntau %+c $+ $nsmSC.PhaseGenerate(13Socket Counter v3.0a6 by 13Kuntau) $+ %+c
  nsmSC.SockPriv #kuntau %+c $+ $nsmSC.PhaseGenerate(06This result best viewed using font 13FixedSys6 with size 139) $+ %+c
  nsmSC.SockPriv #kuntau %+c $+ $nsmSC.PhaseGenerate(6- 13END OF SCRIPT6 -) $+ %+c
  hfree -w nsmSC.*
}
alias nsmSC.PhaseKick {
  if ($hget(nsmSC.KickTotal,$1)) { var %+nsmSC.KickPrepare = 13 $+ $ifmatch $+ 06 kick $+ $iif($ifmatch > 1,s) $+ 6 }
  else { var %+nsmSC.KickPrepare = 13NO KICK06 *loser* }
  return %+nsmSC.KickPrepare
}
alias nsmSC.PhaseBan {
  if ($hget(nsmSC.BanTotal,$1)) { var %+nsmSC.BanPrepare = 13 $+ $ifmatch $+ 06 ban $+ $iif($ifmatch > 1,s) $+ 6 }
  else { var %+nsmSC.BanPrepare = 13NO BAN06 *cheater* }
  return %+nsmSC.BanPrepare
}
alias nsmSC.PhaseBanx {
  if ($hget(nsmSC.BanTotal,$1) { var %+nsmSC.BanPrepare = 13 $+ $ifmatch $+ 06 kick $+ $iif($ifmatch > 1,s) $+ 6 }
  else { var %+nsmSC.KickPrepare = 13NO KICK06 *loser* }
  return %+nsmSC.KickPrepare
}
alias nsmSC.PhaseGenerate {
  var %+nsmPC.1st = $len($strip($1-)), %+nsmPC.Last = $calc((80 - %+nsmPC.1st) / 2)
  return $str( ,%+nsmPC.Last) $+ $1- $+ $str( ,%+nsmPC.Last) $+ $iif($chr(46) isin %+nsmPC.Last, )
}
;13|6•13|

on *:signal:nsmSC.*: {
  ;e ::: $signal ::: $1-
  if ($signal == nsmSC.kick) {
    .hinc -m nsmSC.KickTotal $2
    .hinc -m nsmSC.General Kicked
    $iif(!$hget(nsmSC.General,FirstKick),hadd -m nsmSC.General FirstKick $2)
  }
  if ($signal == nsmSC.Ban) {
    .hinc -m nsmSC.BanTotal $2 $count($3,b) 
    .hadd -m nsmSC.General Baned $calc($hget(nsmSC.General,Baned) + $count($3,b))
    $iif(!$hget(nsmSC.General,FirstBan),hadd -m nsmSC.General FirstBan $2)
  }
  .hinc -m nsmSC.ActTotal $2
  .timer $+ $1 1 15 nsmSC.PhaseInit
}

;always dc if chatting while kicking ? on this input and your sock bot will talk for you. nice eh
;escape key for normal text is ctrl + enter in-case you dont know
#nsmSC.SockInput off
on *:INPUT:*:{
  if ($active == Status Window) && ($left($1,1) != /) { nS.logo Please use " / " before typing " $1- " or any command in Status Window  | halt }
  $iif($left($1,1) == $chr(47) || ($ctrlenter) || !$sock(myric).status,return)
  nS.priv $active $repnick($1-)
  halt 
}
#nsmSC.SockInput end
on *:load: { nsmSC.SockEcho Sock counter v3.0a loaded !!! | set %+nsmSC.CounterNick MyRIC[Counter $+ $r(00,99) | set %+nsmSC.SockCounter $true }
on *:unload: { nsmSC.SockEcho Sock counter v3.0a unloaded !!! | unset %+nsmSC.* }

;menu... nothing to explain LOL
menu menubar,channel {
  -
  $iif($sock(nsmSC.SockCounter).status,Sockclose ( Active ),Sockopen ( Inactive )) :{ $iif(!$sock(nsmSC.SockCounter).status,nsmSC.SockOpen,nsmSC.SockClose) }
  -
  $iif(!$sock(nsmSC.SockCounter).status,,$iif(%+nsmSC.CounterNick !ison #,Join Counter ( $active ),Part Counter ( $active ))) :{ $iif(%+nsmSC.CounterNick ison #,nsmSC.SockPart #,nsmSC.SockJoin #) | nsmSC.SockEcho Status: $iif(%+nsmSC.SockNick ison #,Parting #,Joining #) }
  Sock Nick ( %nS.nick ) : { var %nS.x = $$?="Please put new sock counter nick" | $iif(%nS.x,set %nS.nick $ifmatch,halt) | nS.logo New sock nick: %nS.nick | $iif($sock(myric).status,nS.nick %nS.x) }
  Sock Input ( $iif($group(#nsmSC.SockInput).status == on,Enable,Disable) ) : { $iif($group(#nsmSC.SockInput).status == on,.disable #nsmSC.SockInput,.enable #nsmSC.SockInput) | nsmSC.SockLogo Sock input: $iif($ifmatch != on,Enabled,Disabled) }
  Sock Counter ( $iif(%+nsmSC.OffCounter,Enable,Disable) ) : { set %+nsmSC.OffCounter $iif(%+nsmSC.OffCounter,$false,$true) | nsmSC.SockEcho Sock counter: $iif(!$ifmatch,Enabled,Disabled) }
}

/*
p.s: dont complain this remote bad coded or can be shorten or anything like that. i write this in 5 minutes ._. nobody perfect LOL
*/
