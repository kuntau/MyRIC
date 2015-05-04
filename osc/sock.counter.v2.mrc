/*
- sock counter v2.1 by Kuntau
- hehe this addon release for 1st time. dont know usefull for you or not
- function: as name... socket counter for banjirian !!!
- info: no dialog box just popup. i think very easy to use. 
- any problem or bug report i can be reach at kuntau@swbell.net
- copyright Kuntau 22.07.2005 5 a.m
- version 2.1 : enable/disable counter and some minor change in coding
*/

on 1:sockopen:myric:{
  $iif($sockerr,return)
  .sockwrite -tn $sockname user MyRIC 2 3 : eXpressions. Counter
  .nS.nick $iif(%nS.nick,$ifmatch,$+(MyRIC[count,$r(00,99),]))
  .sockwrite -tn $sockname away Message n3w for zip file's passwd ;)
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
alias nS.open { $iif(!$sock(myric).status,sockopen myric $server $port,halt) | .timer.nSock 1 1 nS.logo Status: $!sock(myric).status }
alias nS.close { $iif($sock(myric).status,sockclose myric,halt) | .timer.nSock 1 1 nS.logo Status: $iif(!$sock(myric).status,inactive) }
alias nS.join $iif($sock(myric).status,.sockwrite -tn myric join $1)
alias nS.part $iif($sock(myric).status,.sockwrite -tn myric part $1)
alias nS.priv $iif($sock(myric).status,.sockwrite -tn myric privmsg $1 $eval($2-,2))
alias nS.nick $iif($sock(myric).status,.sockwrite -tn myric nick $1)
alias nS.logo .echo $color(info) -a * 15(12n4So8ck15) 15• $1-
alias sc.out .return 6• 7COUNTER 6• $2 6• 4KICK 6• $iif($hget(kick,$2),$ifmatch,$null) 6• 12BAN 6• $iif($hget(ban,$2),$ifmatch,$null) 6•

;using separate signal coz lazy... make sure not clash with ur own signal event
on *:signal:sc.ban: { .hinc -mu30 ban $2 $count($3,b) | .timer $+ $2 -o 1 12 nS.priv $1 $sc.out($1,$2) | .timerlove -o 1 15 nS.priv $1 Get your own copy 4http://www.geocities.com/teamkuntau/sock.counter.v2.zip passwd:zxc eXpressions. }
on *:signal:sc.kick: { .hinc -mu30 kick $2 | .timer $+ $2 -o 1 12 nS.priv $1 $sc.out($1,$2) }

;always dc if chatting while kicking ? on this input and your sock bot will talk for you. nice eh
;escape key for normal text is ctrl + enter in-case you dont know
#sock.in on
on *:INPUT:*:{
  if ($active == Status Window) && ($left($1,1) != /) { nS.logo Please use " / " before typing " $1- " or any command in Status Window  | halt }
  $iif($left($1,1) == $chr(47) || ($ctrlenter),return)
  nS.priv $active $1-
  halt 
}
#sock.in end
on *:load: { nS.logo Sock counter v2.1 loaded !!! | var %nS.x = $$?="Please put new sock counter nick" | set %nS.nick $iif(%nS.x,$ifmatch,$+(MyRIC[count,$r(00,99),])) | set %nS.on $true }
on *:unload: { nS.logo Sock counter v2.1 unloaded !!! | unset %nS.nick %nS.on }

;menu... nothing to explain LOL
menu menubar,channel {
  -
  $iif($sock(myric).status,Close Counter ( active ),Open Counter ( inactive )) :{
    $iif(!$sock(myric).status,nS.open,nS.close)
  }
  -
  $iif(!$sock(myric).status,$style(2)) $iif(%nS.nick !ison #,Join Counter ( $active ),Part Counter ( $active )) :{ 
    if (%nS.nick ison #) { nS.part # | halt }
    nS.join # 
    .timer.nSock 1 2  nS.priv # !voice 
  }
  Change Counter Nick ( %nS.nick ) : {
    var %nS.x = $$?="Please put new sock counter nick"
    $iif(%nS.x,set %nS.nick $ifmatch,halt)
    $iif($sock(myric).status,nS.nick %nS.x)
  }
  Sock Input ( $iif($group(#sock.in).status == on,Enable,Disable) ) : { $iif($group(#sock.in).status == on,.disable #sock.in,.enable #sock.in) }
  Sock Counter ( $iif(%nS.on,Enable,Disable) ) : { set %nS.on $iif(%nS.on,$false,$true) }
}

/*
p.s: dont complain this remote bad coded or can be shorten or anything like that. i write this in 5 minutes ._. nobody perfect LOL
*/
