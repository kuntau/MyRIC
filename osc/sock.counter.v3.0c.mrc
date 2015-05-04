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
  .timer.nsmSC.away 1 5 .sockwrite -tn $sockname away $nsmSC.SockAdv
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
alias nsmSC.SockClose { $iif($sock(nsmSC.SockCounter).status,sockclose nsmSC.SockCounter,halt) | .timernsmSC.Sock 1 1 nsmSC.SockEcho Status: $iif(!$sock(nsmSC.SockCounter).status,inactive) }
alias nsmSC.SockJoin { if ($sock(nsmSC.SockCounter).status) { .sockwrite -tn nsmSC.SockCounter join $1 | .timernscSC.Sock 1 2  nsmSC.SockPriv $1 !voice } }
alias nsmSC.SockPart $iif($sock(nsmSC.SockCounter).status,.sockwrite -tn nsmSC.SockCounter part $1)
alias nsmSC.SockPriv $iif($sock(nsmSC.SockCounter).status,.sockwrite -tn nsmSC.SockCounter privmsg $1 $replacecs($2-,:fade:,%+nsmSC.Fade,:high:,%+nsmSC.High))
;alias nsmSC.SockPriv $iif($sock(nsmSC.SockCounter).status,.sockwrite -tn nsmSC.SockCounter privmsg $1 $eval($2-,2))
alias nsmSC.SockNick $iif($sock(nsmSC.SockCounter).status,.sockwrite -tn nsmSC.SockCounter nick $1)
alias nsmSC.SockEcho .echo $color(info) -a * $nsmSC.SockLogo 13• $1-
alias nsmSC.SockLogo return 13@06nsm`13S06ock13C06ounter
;alias nS.adv return Get your own copy of Socket counter addon at: 4http://www.geocities.com/teamkuntau/sock.counter.v2.1.zip zip password: 4zxc eXpressions. 
alias nsmSC.SockAdv return 13S6ock 13C6ounter 13v3.0a 6by 13Kuntau *6will be release soon13*

alias nsmSC.PhaseInit {
  var %+nsmSC.ActTotal = $hget(nsmSC.ActTotal,0).item, %+nsmSC.ActCount = 1
  set %+nsmSC.High $read(color.txt)
  set %+nsmSC.Fade 00
  set %+nsmSC.:C:. :fade:[:high:$:fade:]:fade:
  nsmSC.SockPriv $1 %+nsmSC.:C:. $+ $nsmSC.PhaseHeading(:fade:[ :high:Socket Counter v3.0c:fade: ]) $+ %+nsmSC.:C:.
  nsmSC.SockPriv $1 %+nsmSC.:C:. $+ $nsmSC.PhaseGenerate(Result as $time(dddd. ddoo mmmm yyyy h.nntt) ) $+ %+nsmSC.:C:.
  nsmSC.SockPriv $1 %+nsmSC.:C:. $+ $nsmSC.PhaseHeading(:fade:[ :high:Kick:fade: & :high:Ban Result:fade: ]) $+ %+nsmSC.:C:.
  while (%+nsmSC.ActCount <= %+nsmSC.ActTotal) {
    var %+nsmSC.ActNick = $hget(nsmSC.ActTotal,%+nsmSC.ActCount).item
    var %+nsmSC.KickTotal = $nsmSC.PhaseKick(%+nsmSC.ActNick)
    var %+nsmSC.BanTotal = $nsmSC.PhaseBan(%+nsmSC.ActNick)
    var %+nsmSC.ActResult = :fade:Result for :high: $+ %+nsmSC.ActNick $+ :fade: are %+nsmSC.KickTotal & %+nsmSC.BanTotal
    nsmSC.SockPriv $1 %+nsmSC.:C:. $+ $nsmSC.PhaseGenerate(%+nsmSC.ActResult) $+ %+nsmSC.:C:.
    inc %+nsmSC.ActCount
  }
  nsmSC.SockPriv $1 %+nsmSC.:C:. $+ $nsmSC.PhaseHeading(:fade:[ :high:Round Statistics:fade: ]) $+ %+nsmSC.:C:.
  nsmSC.SockPriv $1 %+nsmSC.:C:. $+ $nsmSC.PhaseGenerate(:fade:First person kick is $nsmSC.PhaseStats(FirstKick) & first person ban is $nsmSC.PhaseStats(FirstBan)) $+ %+nsmSC.:C:.
  nsmSC.SockPriv $1 %+nsmSC.:C:. $+ $nsmSC.PhaseGenerate(:fade:Last person kick is $nsmSC.PhaseStats(LastKick) & last person ban is $nsmSC.PhaseStats(LastBan)) $+ %+nsmSC.:C:.
  nsmSC.SockPriv $1 %+nsmSC.:C:. $+ $nsmSC.PhaseGenerate(:fade:Total of $nsmSC.PhaseStats(kicked) & $nsmSC.PhaseStats(baned) been made by $nsmSC.PhaseStats(TotalAct) on :high: $+ $1 $+ :fade:) $+ %+nsmSC.:C:.
  nsmSC.SockPriv $1 %+nsmSC.:C:. $+ $nsmSC.PhaseHeading(:fade:[ :high:Message Of The Day:fade: ]) $+ %+nsmSC.:C:.
  ;nsmSC.SockPriv $1 %+nsmSC.:C:. $+ $nsmSC.PhaseGenerate(:high:Socket Counter v3.0a:fade: by :high:Kuntau) $+ %+nsmSC.:C:.
  nsmSC.SockPriv $1 %+nsmSC.:C:. $+ $nsmSC.PhaseGenerate(:fade:This result best viewed using font :high:FixedSys:fade: $+ $chr(44) :high:Courier :fade:& :high:Courier new) $+ %+nsmSC.:C:.
  nsmSC.SockPriv $1 %+nsmSC.:C:. $+ $nsmSC.PhaseHeading(:fade:[ :high:End of Report:fade: ]) $+ %+nsmSC.:C:.
  nsmSC.PhaseMost
  hfree -w nsmSC.*
}
alias nsmSC.PhaseKick {
  if ($hget(nsmSC.KickTotal,$1)) { var %+nsmSC.KickPrepare = :high: $+ $ifmatch $+ :fade: kick $+ $iif($ifmatch > 1,s) }
  else { var %+nsmSC.KickPrepare = no kick! :high:*:fade:loser:high:*:fade: }
  return %+nsmSC.KickPrepare
}
alias nsmSC.PhaseBan {
  if ($hget(nsmSC.BanTotal,$1)) { var %+nsmSC.BanPrepare = :high: $+ $ifmatch $+ :fade: ban $+ $iif($ifmatch > 1,s) }
  else { var %+nsmSC.BanPrepare = no ban! :high:*:fade:cheater:high:*:fade: }
  return %+nsmSC.BanPrepare
}
alias nsmSC.PhaseStats {
  if ($1 == TotalAct && $hget(nsmSC.ActTotal,0).item) { var %+nsmSC.StatsPrepare = :high: $+ $ifmatch $+ :fade: user $+ $iif($ifmatch > 1,s) $+ :fade: }
  if ($1 == TotalAct && !$hget(nsmSC.ActTotal,0).item) { var %+nsmSC.StatsPrepare = :high:no one!:fade: :high:*:fade:no user here?:high:*:fade: }
  if ($1 == Kicked && $hget(nsmSC.General,Kicked)) { var %+nsmSC.StatsPrepare = :high: $+ $ifmatch $+ :fade: kick $+ $iif($ifmatch > 1,s) $+ :fade: }
  if ($1 == Kicked && !$hget(nsmSC.General,Kicked)) { var %+nsmSC.StatsPrepare = :high:0:fade: kick :high:*:fade:no one kick?:high:*:fade: }
  if ($1 == Baned && $hget(nsmSC.General,Baned)) { var %+nsmSC.StatsPrepare = :high: $+ $ifmatch $+ :fade: ban $+ $iif($ifmatch > 1,s) $+ :fade: }
  if ($1 == Baned && !$hget(nsmSC.General,Baned)) { var %+nsmSC.StatsPrepare = :high:0:fade: ban :high:*:fade:no one ban?:high:*:fade: }
  if ($1 == FirstKick && $hget(nsmSC.General,FirstKick)) { var %+nsmSC.StatsPrepare = :high: $+ $ifmatch $+ :fade: }
  if ($1 == FirstKick && !$hget(nsmSC.General,FirstKick)) { var %+nsmSC.StatsPrepare = :high:NO ONE:fade: :high:*:fade:wtf?:high:*:fade: }
  if ($1 == FirstBan && $hget(nsmSC.General,FirstBan)) { var %+nsmSC.StatsPrepare = :high: $+ $ifmatch $+ :fade: }
  if ($1 == FirstBan && !$hget(nsmSC.General,FirstBan)) { var %+nsmSC.StatsPrepare = :high:NO ONE:fade: :high:*:fade:wth?:high:*:fade: }
  if ($1 == LastKick && $hget(nsmSC.General,LastKick)) { var %+nsmSC.StatsPrepare = :high: $+ $ifmatch $+ :fade: }
  if ($1 == LastKick && !$hget(nsmSC.General,LastKick)) { var %+nsmSC.StatsPrepare = :high:NO ONE:fade: :high:*:fade:wtf?:high:*:fade: }
  if ($1 == LastBan && $hget(nsmSC.General,LastBan)) { var %+nsmSC.StatsPrepare = :high: $+ $ifmatch $+ :fade: }
  if ($1 == LastBan && !$hget(nsmSC.General,LastBan)) { var %+nsmSC.StatsPrepare = :high:NO ONE:fade: :high:*:fade:wth?:high:*:fade: }
  return %+nsmSC.StatsPrepare
}
alias nsmSC.PhaseMost {
  var %+nsmSC.KickerTotal = $hget(nsmSC.KickTotal,0).item, %+nsmSC.KickerCount = 1, %+nsmSC.MostResult = 1
  while (%+nsmSC.KickerCount <= %+nsmSC.KickerTotal) {
    var %+nsmSC.KickerNick = $hget(nsmSC.KickTotal,%+nsmSC.KickerCount).item
    var %+nsmSC.KickerKick = $hget(nsmSC.KickTotal,%+nsmSC.KickerNick)
    var %+nsmSC.MostResult = $iif(%+nsmSC.KickerKick > %+nsmSC.MostResult,%+nsmSC.KickerKick,%+nsmSC.MostResult)
    echo -a %+nsmSC.KickerNick --> %+nsmSC.KickerKick ---> %+nsmSC.MostResult

    ;var %+nsmSC.ActResult = :fade:Result for :high: $+ %+nsmSC.ActNick $+ :fade: are %+nsmSC.KickTotal & %+nsmSC.BanTotal
    ;nsmSC.SockPriv $1 %+nsmSC.:C:. $+ $nsmSC.PhaseGenerate(%+nsmSC.ActResult) $+ %+nsmSC.:C:.
    inc %+nsmSC.KickerCount
  }
  echo -ae %+nsmSC.MostResult
}
alias nsmSC.PhaseMostFinal {
  var %+nsmSC.MostTotal = $hget(nsmSC.KickTotal,0).item, %+nsmSC.MostCount = 1, %+nsmSC.MostResult = $1
  while (%+nsmSC.MostCount <= %+nsmSC.MostTotal) {
    var %+nsmSC.KickerNick = $hget(nsmSC.KickTotal,%+nsmSC.KickerCount).item
    var %+nsmSC.KickerKick = $hget(nsmSC.KickTotal,%+nsmSC.KickerNick)
    var %+nsmSC.MostResult = $iif(%+nsmSC.KickerKick > %+nsmSC.MostResult,%+nsmSC.KickerKick,%+nsmSC.MostResult)
    echo -a %+nsmSC.KickerNick --> %+nsmSC.KickerKick ---> %+nsmSC.MostResult

    inc %+nsmSC.MostCount
  }
  echo -ae %+nsmSC.MostResult
}
alias nsmSC.PhaseGenerate {
  var %+nsmSC.init = $replacecs($1-,:fade:,%+nsmSC.Fade,:high:,%+nsmSC.High), %+nsmPC.1st = $len($strip(%+nsmSC.init)), %+nsmPC.2nd = $calc(80 - %+nsmPC.1st), %+nsmPC.Last = $calc(%+nsmPC.2nd - 5)
  return $str( ,5) $+ %+nsmSC.init $+ $str( ,%+nsmPC.Last) $+ $iif($chr(46) isin %+nsmPC.Last, )
}
alias nsmSC.PhaseCenter {
  var %+nsmSC.init = $replacecs($1-,:fade:,%+nsmSC.Fade,:high:,%+nsmSC.High), %+nsmPC.1st = $len($strip(%+nsmSC.init)), %+nsmPC.Last = $calc((80 - %+nsmPC.1st) / 2)
  return $str( ,%+nsmPC.Last) $+ %+nsmSC.init $+ $str( ,%+nsmPC.Last) $+ $iif($chr(46) isin %+nsmPC.Last, )
}
alias nsmSC.PhaseHeading {
  var %+nsmSC.init: = $replacecs($1-,:fade:,%+nsmSC.Fade,:high:,%+nsmSC.High), %+nsmPC.1st: = $len($strip(%+nsmSC.init:)), %+nsmPC.Last: = $calc((80 - %+nsmPC.1st:) / 2)
  return $str(-,%+nsmPC.Last:) $+ %+nsmSC.init: $+ $str(-,%+nsmPC.Last:) $+ $iif($chr(46) isin %+nsmPC.Last:,-)
}
;13|:fade:•13|

on *:signal:nsmSC.*: {
  ;e ::: $signal ::: $1-
  if ($signal == nsmSC.kick) {
    .hinc -m nsmSC.KickTotal $2
    .hinc -m nsmSC.General Kicked
    $iif(!$hget(nsmSC.General,FirstKick),hadd -m nsmSC.General FirstKick $2)
    hadd -m nsmSC.General LastKick $2
  }
  if ($signal == nsmSC.Ban) {
    .hinc -m nsmSC.BanTotal $2 $count($3,b) 
    .hadd -m nsmSC.General Baned $calc($hget(nsmSC.General,Baned) + $count($3,b))
    $iif(!$hget(nsmSC.General,FirstBan),hadd -m nsmSC.General FirstBan $2)
    hadd -m nsmSC.General LastBan $2
  }
  .hinc -m nsmSC.ActTotal $2
  .timer $+ $1 1 15 nsmSC.PhaseInit $1
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
on *:load: { nsmSC.SockEcho Sock counter v3.0a loaded !!! | set %+nsmSC.CounterNick MyRIC[Counter $+ $r(00,99) | set %+nsmSC.SockCounter $true | set %+nsmSC.:C:. 00[7$00]00 | set %+nsmSC.High 07 | set %+nsmSC.Fade 00 }
on *:unload: { nsmSC.SockEcho Sock counter v3.0a unloaded !!! | unset %+nsmSC.* | hfree -w nsmSC.* }

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
