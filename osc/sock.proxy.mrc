;ping

alias check.lag { $iif(!$server,return) | .ctcp $me $+(lag.,$ticks) }
ctcp *:lag.*:?:if ($nick == $me) && ($gettok($1,2,46) isnum) { echo -a 13* Lag: $calc(($ticks - $gettok($1,2,46)) / 1000) sec(s) }

;test sock proxy
alias myric { .sockopen myric 210.0.209.108 3128 }
alias nS.open { $iif(!$sock(myric).status,sockopen myric 220.65.55.19 8080,halt) | .timer.nSock 1 1 nS.logo Status: $!sock(myric).status }
alias nS.close { $iif($sock(myric).status,sockwrite -tn myric quit %o,halt) | .timer.nSock 1 1 nS.logo Status: $iif(!$sock(myric).status,inactive) }
alias nS.join $iif($sock(myric).status,.sockwrite -tn myric join $1)
alias nS.part $iif($sock(myric).status,.sockwrite -tn myric part $1)
alias nS.priv $iif($sock(myric).status,.sockwrite -tn myric privmsg $1 $eval($2-,2))
alias nS.nick $iif($sock(myric).status,.sockwrite -tn myric nick $1)
alias nS.logo .echo $color(info) -a * 15(12n4So8ck15) 15• $1-
;210.95.17.253 3128
;210.0.209.108 3128
;/firewall on 211.252.175.65 3128
;/firewall on 220.65.55.19 8080
;/firewall on 219.93.174.108 80
ON 1:SOCKOPEN:myric: {
  if ($sockerr)  { return }
  ;.sockwrite -tn $sockname CONNECT $server $+ : $+ $port $+(HTTP/1.0,$CRLF,$CRLF)
  .sockwrite -tn $sockname CONNECT 140.120.13.217:6669 $+(HTTP/1.0,$CRLF,$CRLF)
}
ON 1:SOCKREAD:myric:{
  if ($sockerr) { return }
  .sockread %s.read
  if (!$sockbr) return
  if ($gettok(%s.read,1-2,32) == HTTP/1.0 200) || ($gettok(%s.read,1-2,32) == HTTP/1.1 200) {
    .sockwrite -tn $sockname NICK %s.nick
    .sockwrite -tn $sockname USER l337. $+ $r(0,9) $+ $r(0,9) $r(a,z) $r(a,z) : $+ 1401d pr0gr4mm3r5 n3v3r di3. 7h3y ju57 15br4nch14 70 4 n3w 4ddr355.
    ;.timer.s.away 1 3 sockwrite -tn $sockname away 14134rn 70 r34d15;14 r34d 70 134rn15;
  } 
  if ($gettok(%s.read,1,32) == PING) { sockwrite -tn $sockname PONG : $gettok(%s.read,2,58) | return }
  return
  var %s.raw = $gettok(%s.read,2,32), %s.chan = $gettok(%s.read,3,32), %s.nix = $gettok($gettok(%s.read,1,58),1,33), %s.$1- = $strip($gettok(%s.read,2,58))
  if ($regex(%:raw,/(442|404|403|927|474|478)/)) { return }
  ;echo @test 04 $+ %s.raw $+  c = %s.chan ::: n = %s.nix ::: x = %s.$1-
  if ($mid(%s.read,1,4) == PING) { .sockwrite -tn $sockname PONG $remove($remove(%s.read,ping :),ping) | halt }
  if (quit isin %s.read) && (%s.nick isin %s.read) { nS.open | var %:c = 1 | while ($comchan($me,0) >= %c) { nS.join $comchan($me,%:c) | inc %:c } }
  .unset %s.read
}
;ON 1:SOCKCLOSE:myric:{ nS.open }
;ON *:NOTIFY:{ $iif($nick ison #,halt) | echo -a $event ::: $nick = %s.nick | .timer.s.join 1 2 nS.join $active | .timer.nSock 1 2  nS.priv # !op }
;ON *:UNOTIFY:{ .timer.s.open 1 1 ns.open }
alias oss { ns identify K|ck nsm1984 | timer 1 1 os oper K|ck 753082 }
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
