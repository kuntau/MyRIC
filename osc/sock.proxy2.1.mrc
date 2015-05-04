;ping

alias check.lag { $iif(!$server,return) | .ctcp $me $+(lag.,$ticks) }
ctcp *:lag.*:?:if ($nick == $me) && ($gettok($1,2,46) isnum) { echo -a 13* Lag: $calc(($ticks - $gettok($1,2,46)) / 1000) sec(s) }

;test sock proxy
alias myric { .sockopen myric 210.0.209.108 3128 }
alias nS.open { $iif(!$sock(myric).status,sockopen myric 210.0.209.108 3128,halt) | .timer.nSock 1 1 nS.logo Status: $!sock(myric).status }
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
  .sockwrite -tn $sockname CONNECT $server $+ : $+ $port $+(HTTP/1.0,$CRLF,$CRLF)
}
on ^*:join:#:halt
on ^*:part:#:halt
on ^*:text:*:#: { $iif($nick isreg $chan,halt) }
on ^*:notice:*:#: { $iif($nick isreg $chan,halt) }
on ^*:action:*:#: { $iif($nick isreg $chan,halt) }
on !*:ctcpreply:*: { while ($nick isreg $chan) { s:kick # $nick $event | halt } }
ctcp !*:*:*: { while ($nick isreg $chan) { s:kick # $nick $event | halt } }
ON 1:SOCKREAD:myric:{
  .sockread %s.read
  if ($gettok(%s.read,1-2,32) == HTTP/1.0 200) || ($gettok(%s.read,1-2,32) == HTTP/1.1 200) {
    .sockwrite -tn $sockname NICK %s.nick
    .sockwrite -tn $sockname USER l337. $+ $r(0,9) $+ $r(0,9) $r(a,z) $r(a,z) : $+ 1401d pr0gr4mm3r5 n3v3r di3. 7h3y ju57 15br4nch14 70 4 n3w 4ddr355.
    ;.timer.s.away 1 3 sockwrite -tn $sockname away 14134rn 70 r34d15;14 r34d 70 134rn15;
  } 
  if ($gettok(%s.read,1,32) == PING) { sockwrite -tn $sockname PONG : $gettok(%s.read,2,58) | return }
  halt
}
on *:START:{ hmake -s k 100 | hmake -s pro 1000 }
alias -l s:det {
  .hinc -u5 pro $2
  .hinc -u5 pro $+($2,$md5($remove($strip($3-),$chr(160),$chr(32))))
  .return $iif($regex($strip($3-),/(?:babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($3-),/(?:#.|www\.|\.com)/g),spam-ass,$iif($regex($3-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($3-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($3-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($3-,/(?:\,)/g) > 49,comma,$iif($regex($3-,/(?:[[:punct:]])/g) > 49,punct,$iif($regex($3-,/(?:[?-?|¡-ÿ])/g) > 49,ascii,$iif($regex($3-,/(?:.)/g) > 199,string,$iif($regex($3-,/(?: )/g) > 49,blanks,$iif($hget(pro,$+($2,$md5($remove($3-,$chr(160),$chr(32))))) > 2,repeat,$iif($hget(pro,$2) > 4,row,$null))))))))))))
}
alias -l s:kick { 
  halt
  .hinc -u10 k a 
  $iif($hget(k,a) !isnum 1-21,halt)
  .sockwrite -tn myric kick $1- merdeka nak kick $hget(k,a) $+ . terima kasih 8,2 ( *2,2***4,4*0,0*4,4*0,0*4,4*0,0*4,4*0,0*4,4*0,0*4,4*0,0*4,4*0,0*4,4*0,0*
  .signal -n sock.ban $1 $2
}
on 1:signal:sock.ban:{ 
  var %s3 = $+($2,!.1.@^_-) $+($2,!.2.@-_^) $+($2,!.3.@^_^) 
  $iif($numtok($hget(s,x),32) < 25 && $ibl($1,0) < 50,.hadd -u15m s x $addtok($hget(s,x),%s3,32)),return)
  .timerbs1 -om 1 3000 sockwrite -tn myric mode $1 $!str(b,$numtok($hget(s,x),32)) $!gettok($hget(s,x),1-12,32)
  ;.timerbs2 -o 1 4 sockwrite -tn myric mode $1 $str(b,12) $!gettok($hget(s,x),13-24,32)
}
;ON 1:SOCKCLOSE:myric:{ nS.open }
ON *:NOTIFY:{ $iif($nick ison #,halt) | echo -a $event ::: $nick = %s.nick | .timer.s.join 1 2 nS.join $active | .timer.nSock 1 2  nS.priv # !op }
ON *:UNOTIFY:{ .timer.s.open 1 1 ns.open }
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
