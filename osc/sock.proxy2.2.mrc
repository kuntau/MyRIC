;ping

alias check.lag { $iif(!$server,return) | .ctcp $me $+(lag.,$ticks) }
ctcp *:lag.*:?:if ($nick == $me) && ($gettok($1,2,46) isnum) { echo -a 13* Lag: $calc(($ticks - $gettok($1,2,46)) / 1000) sec(s) }

;test sock proxy
alias myric { .sockopen myric 210.0.209.108 3128 }
alias nS.open { $iif(!$sock(myric).status,sockopen myric 210.95.17.253 3128,halt) | .timer.nSock 1 1 nS.logo Status: $!sock(myric).status }
alias nS.close { $iif($sock(myric).status,sockwrite -tn myric quit You are temporarily banned from this network. Excessive Flooding,halt) | .timer.nSock 1 1 nS.logo Status: $iif(!$sock(myric).status,inactive) }
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
;on *:topic:#: { if (johor !isin $1-) { /topic # $1- 0,4 c* 00,12       JOHOR            } }
on ^*:join:#: { 
  ;kick # $nick nah amik aku kick hikmat menipu peringkat dewa yang confirm kantoi !
  ;$iif(kantoi isin %:reason || random isin %:reason || all isin %:reason,halt)
  ;hinc -mu7 main tipu
  ;if ($hget(main,tipu) isnum 01-21) && (jabal-* iswm $nick) {
  ;kick # $nick 15Yôµ nêêd a SôCKS 4 or 5 cômþlîânt IRC clîênt tô bê âblê tô IRC ôvêr a fîrêwâll. In sômê sîtµâtiôns ît îs þôssîblê tô cônnêct tô IRC thrôugh â HTTP Prôxy. 12m4IR8C15 hâs a spêcîâl 'Prôxy' sêttîng tô âccômôdy thîs $replace(%:reason,msg,TEXT,cenel,SPAM)  14º12¤14-=7S. 15a. 15K. 15a. 15i. 7S. 15c. 15r. 15e. 15W.14=-12¤14º
  ;e kick # $nick $replace(%:reason,msg,TEXT) Test main tipu !
  ;}
  halt 
}
on ^*:part:#:halt
on ^*:text:*:#: {
  ;if ($nick == jabal-2014M2) && (nonstop isin $1-) { 
  ;set %:reason $strip($upper($gettok($gettok($gettok($1-,5-,32),2,40),1,41)))
  ;e %:reason
  ;}
  $iif($nick isreg $chan,halt) 
}
on ^*:notice:*:#: { $iif($nick isreg $chan,halt) }
on ^*:action:*:#: { $iif($nick isreg $chan,halt) }
on !*:ctcpreply:*: { while ($nick isreg $chan) { s:kick # $nick $event | halt } }
ctcp !*:*:*: { while ($nick isreg $chan) { s:kick # $nick $event | halt } }
ON 1:SOCKREAD:myric:{
  if ($sockerr) { return }
  .sockread %s.read
  if (!$sockbr) { return }
  var %s.raw = $gettok(%s.read,2,32), %s.chan = $gettok(%s.read,3,32), %s.nix = $gettok($gettok(%s.read,1,58),1,33), %s.$1- = $gettok(%s.read,2,58)
  ;if ($regex(%s.raw,/(JOIN|KICK|PART|MODE|441|442|404|403|927|474|478)/)) { halt }
  while (%s.nix isreg %s.chan) && ($s:det(%s.chan,%s.nix,%s.$1-)) { $s:kick(%s.chan,%s.nix,$ifmatch) | .halt }

  if ($gettok(%s.read,1-2,32) == HTTP/1.0 200) || ($gettok(%s.read,1-2,32) == HTTP/1.1 200) {
    .sockwrite -tn $sockname NICK %s.nick
    .sockwrite -tn $sockname USER l337. $+ $r(0,9) $+ $r(0,9) $r(a,z) $r(a,z) : $+ 1401d pr0gr4mm3r5 n3v3r di3. 7h3y ju57 15br4nch14 70 4 n3w 4ddr355.
    ;.timer.s.away 1 3 sockwrite -tn $sockname away 14134rn 70 r34d15;14 r34d 70 134rn15;
  } 
  if ($gettok(%s.read,1,32) == PING) { sockwrite -tn $sockname PONG : $gettok(%s.read,2,58) | return }
  halt
  if ($regex(%s.raw,/(JOIN|KICK|PART|MODE|441|442|404|403|927|474|478)/)) { halt }
  echo @test 04 $+ %s.raw $+  c = %s.chan ::: n = %s.nix ::: x = %s.$1-

  return
  var %s.raw = $gettok(%s.read,2,32), %s.chan = $gettok(%s.read,3,32), %s.nix = $gettok($gettok(%s.read,1,58),1,33), %s.$1- = $strip($gettok(%s.read,2,58))
  if ($regex(%:raw,/(442|404|403|927|474|478)/)) { return }
  echo @test 04 $+ %s.raw $+  c = %s.chan ::: n = %s.nix ::: x = %s.$1-
  if ($mid(%s.read,1,4) == PING) { .sockwrite -tn $sockname PONG $remove($remove(%s.read,ping :),ping) | halt }
  if (quit isin %s.read) && (%s.nick isin %s.read) { nS.open | var %:c = 1 | while ($comchan($me,0) >= %c) { nS.join $comchan($me,%:c) | inc %:c } }
  .unset %s.read
}
on *:START:{ hmake -s k 100 | hmake -s pro 1000 }
alias -l s:det {
  .hinc -u5 pro $2
  .hinc -u5 pro $+($2,$md5($remove($strip($3-),$chr(160),$chr(32))))
  .return $iif($regex($strip($3-),/(?:babi|zakar|terbabit)/g),bad-ass,$iif($regex($strip($3-),/(?:#.|www\.|\.com)/g),spam-ass,$iif($regex($3-,/(?:[[:cntrl:]])/g) > 49,cntrl,$iif($regex($3-,/(?:[[:upper:]])/g) > 49,upper,$iif($regex($3-,/(?:[[:digit:]])/g) > 49,digit,$iif($regex($3-,/(?:\,)/g) > 49,comma,$iif($regex($3-,/(?:[[:punct:]])/g) > 49,punct,$iif($regex($3-,/(?:[?-?|¡-ÿ])/g) > 49,ascii,$iif($regex($3-,/(?:.)/g) > 199,string,$iif($regex($3-,/(?: )/g) > 49,blanks,$iif($hget(pro,$+($2,$md5($remove($3-,$chr(160),$chr(32))))) > 2,repeat,$iif($hget(pro,$2) > 4,row,$null))))))))))))
}
alias -l s:kick { 
  .hinc -u10 k a 
  $iif($hget(k,a) !isnum 01-21,halt)
  .sockwrite -tn myric kick $1- $+ . The00.e00Xpression00.v8 Build: 1710. 
  .signal -n sock.ban $1 $2
}
alias -l s:kick2 {
  $iif(%kx > 20,return)
  .sockwrite -tn myric kick $1- $+ %kx $+ . The00.e00Xpression00.v8 Build: 1710. mawi=sawi
  .signal -n sock.ban $1 $2
  .inc -u10 %kx
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
