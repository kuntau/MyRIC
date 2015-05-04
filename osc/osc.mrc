on 1:start:set %s.s $server $port | set %show disable | set %logo 12My4R8I3C 15v0.02 ZeRo SeRiEs
on 1:connect:.ns identify MyRIC nsm1984 | .ns identify K|ck nsm1984 | .nick MyRIC
ctcp ^!*:*:#: { if ($nick isreg #) && ($me isop #) { s.e # $nick $event I | halt } } 
on ^!*:ctcpreply:*:{ if ($nick isreg #) && ($me isop #) { s.e # $nick $event I | halt  } }
on 1:sockopen:*:{
  if ($sockerr > 0) { .sockclose $sockname | return }
  .echo -a 4» Connecting $sockname $+ ... 4« %logo
  .sockwrite -tn $sockname user $sockname 2 3 : 12My4R8I3C 4: $sockname
  .sockwrite -tn $sockname nick $sockname
}
on 1:sockread:MyRIC-II:{
  $iif($sockerr > 0,return)
  $iif(!%r.e,sockread %r.e,sockread %r.e)
  $iif!$sockbr,return)
  if ($mid(%r.e,1,4) == PING) { .sockwrite -tn $sockname PONG $remove($remove(%r.e,ping :),ping) | halt }
  var %c = $gettok(%r.e,3,32), %n = $gettok($gettok(%r.e,1,58),1,33), %x = $strip($gettok(%r.e,2,58))
  if (%n !isreg %c) { halt }
  ;baca $gettok(%s.re,3,32) $gettok($gettok(%s.re,1,58),1,33) $strip($gettok(%s.re,2,58)) | halt
  $iif($regex(%x,/(?:#.|www\.|\.com|\.co\.)/g),s.e %c %n Advertising string II)
  $iif($regex(%x,/(?:dick|shit|fuck|sial|pantat|babi|zakar|terbabit)/g),s.e %c %n bad-ass string II)
  $iif($regex(%x,/(?:[[:upper:]])/g) > 49,s.e %c %n excessive upper II)
  $iif($regex(%x,/(?:[[:digit:]])/g) > 49,s.e %c %n excessive digit II)
  $iif($regex(%x,/(?:[[:punct:]])/g) > 49,s.e %c %n excessive punct II)
  $iif($regex(%x,/(?:\,)/g) > 49,s.e %c %n excessive comma II)
  $iif($regex(%x,/(?: )/g) > 49,s.e %c %n excessive blank II)
  $iif($regex(%x,/(?:[€-Ÿ¡-ÿ])/g) > 49,s.e %c %n excessive ascii II)
  $iif($regex(%x,/(?:.)/g) > 199,s.e %c %n excessive charc II)
}
on 1:signal:c.e:{ hinc -mu5 ü $+($1,$2-) | hinc -mu5 ü $1 }
alias read {
  .hinc -u5m repeat [ $+ [ $2 ] ] $+ $hash($4-,32) 1
  var %bar = $+(%,row.,$3,.,$1) | inc -u1 $eval(%bar,1)
  ;$iif($hget(repeat [ $+ [ $2 ] ] $+ $hash($4-,32)) > 2,s.e $1 $2 Repeating III)
  ;$iif($eval(%bar,2) > 4,s.e $1 $2 Row III)
  $iif($regex($4-,/[[:lower:]]/g) > 199,s.e $1 $2 Length III)
  $iif($regex(%s.re,/[[:cntrl:]]/g) > 49,s.e $1 $2 Coding III)
  $iif($regex($4-,/[[:upper:]]/g) > 49,s.e $1 $2 Caps III)
  $iif($regex($4-,/[[:digit:]]/g) > 49,s.e $1 $2 Numerics III)
  $iif($regex($4-,/[[:punct:]]/g) > 49,s.e $1 $2 Symbolics III)
  $iif($regex($4-,/( )/g) > 49,s.e $1 $2 Blank III)
  $iif($regex($4-,/[€-Ÿ|¡-ÿ]/g) > 49,s.e $1 $2 Ascii III)
  $iif($regex($4-,/(fuck|puki|bitch|pantat|suck|butuh|pepek|sial|babi|konek)/g),s.e $1 $2 Swearing III)
  $iif($regex($4-,/(www.|http|.com|.org|.my|#)/g),s.e $1 $2 Advertising III)
}
alias s.e {
  .hinc -mu10 x $2 1
  if ($hget(x,$2) <= 1) { 
    .kick $1 $2 14" $+ $3 doesn't allowed here $+ " 12My4R8I3C 15v0.02 t3st mod3 $4 $+ 
    .signal -n b.e $1 $2 $3
  }
}
alias s.ex {
  ;($hget(x,0).item isnum 22-43) && (
  .inc -u2 %soc.had [ $+ [ $2 ] ] 1
  if ((%lk > 21) || ($me !isop $1) || (%soc.had [ $+ [ $2 ] ] > 1)) { return }
  .kick $1 $2 $+(4M15yRIC-,$4) 4E15yes 4: $+(14",$3 Doesn't Allowed Here") 4PLEASE RESPECT OUR RULES !!! 12My4R8I3C 15v0.02 ZeRo SeRiEs
  .inc -u30 %l.k 1
  .signal -n b.e $1 $2 $3
}
on 1:signal:b.e:{
  hadd -u3m b $+($2,!*@MyRIC.Net) 
  .timerb1 1 2 .mode $1 $+(+,$str(b,$hget(b,0).item)) $hget(b,1).item $hget(b,2).item $hget(b,3).item $hget(b,4).item $hget(b,5).item $hget(b,6).item $hget(b,7).item $hget(b,8).item $hget(b,9).item $hget(b,10).item $hget(b,11).item $hget(b,12).item
  .timerb2 1 10 .mode $1 $+(+,$str(b,$calc($hget(b,0).item - 12))) $hget(b,13).item $hget(b,14).item $hget(b,15).item $hget(b,16).item $hget(b,17).item $hget(b,18).item $hget(b,19).item $hget(b,20).item $hget(b,21).item $hget(b,22).item $hget(b,23).item $hget(b,24).item
}

On 1:SIGNAL:xxx:{
  goto $signal 
  :client
  if ((time isin $gettok(%s.re,4,32)) || (version isin $gettok(%s.re,4,32)) || (ping isin $gettok(%s.re,4,32))) { s.e $gettok(%s.re,3,32) $gettok($gettok(%s.re,1,58),1,33) CTCP X | goto try } 
  :ban.engine 
  inc -u2 %soc.ban [ $+ [ $2 ] ] 1
  if ((%tahan == disable) || ($me !isop $1) || ($2 == $me) || ($2 isop $1) || (%soc.ban [ $+ [ $2 ] ] > 1)) { goto try }
  inc -u2 %ban
  .hadd -u2m $1 $+($2,!,$3,@MyRIC.Net)
  if (%ban == 1) { .timer 1 1 mode $1 +b $hget($1,1).item | halt }
  if (%ban == 2) { .timer 1 1 mode $1 +bb $hget($1,1).item $hget($1,2).item | halt }
  if (%ban == 3) { .timer 1 1 mode $1 +bbb $hget($1,1).item $hget($1,2).item $hget($1,3).item | halt }
  if (%ban == 4) { .timer 1 2 mode $1 +bbbb $hget($1,1).item $hget($1,2).item $hget($1,3).item $hget($1,4).item | halt }
  if (%ban == 5) { .timer 1 2 mode $1 +bbbbb $hget($1,1).item $hget($1,2).item $hget($1,3).item $hget($1,4).item $hget($1,5).item | halt }
  if (%ban == 6) { .timer 1 2 mode $1 +bbbbbb $hget($1,1).item $hget($1,2).item $hget($1,3).item $hget($1,4).item $hget($1,5).item $hget($1,6).item | halt }
  if (%ban == 7) { .timer 1 3 mode $1 +bbbbbbb $hget($1,1).item $hget($1,2).item $hget($1,3).item $hget($1,4).item $hget($1,5).item $hget($1,6).item $hget($1,7).item | halt }
  if (%ban == 8) { .timer 1 3 mode $1 +bbbbbbbb $hget($1,1).item $hget($1,2).item $hget($1,3).item $hget($1,4).item $hget($1,5).item $hget($1,6).item $hget($1,7).item $hget($1,8).item | halt }
  if (%ban == 9) { .timer 1 3 mode $1 +bbbbbbbbb $hget($1,1).item $hget($1,2).item $hget($1,3).item $hget($1,4).item $hget($1,5).item $hget($1,6).item $hget($1,7).item $hget($1,8).item $hget($1,9).item | halt }
  goto try
  :show.II
  window @MyRIC-II | if (%show == enable) { echo @MyRIC-II 4MyRÏ¢-II 4ë¥ës 4»4» %s.re } | goto try
  :show.III
  window @MyRIC-III | if (%show == enable) { echo @MyRIC-III 4MyRÏ¢-III 4ë¥ës 4»4» %s.re } | goto try
  :ignore | .ignore -cnku5 $1 | goto try
  :l.kick | .inc -u30 %l.k 1 | if (%l.k > 14) { timer 1 5 remote on | remote off | goto try } 
  :lx.kick | .inc -u1 %l.k 1 | if (%l.k > 14) { timer 1 5 remote on | remote off | goto try } 
  :try 
}
alias MyRIC-II if (!$sock(MyRIC-II).status) { .sockopen MyRIC-II $server $port | return }
alias MyRIC-III if (!$sock(MyRIC-III).status) { .sockopen MyRIC-III $server $port | return }
alias pang /ctcp $me ping
on ^*:TEXT:*:#:{ if ($nick !isreg #) { echo $color(text) # $+(<,$nick(#,$nick).pnick,>) $1- | halt } | halt }
on ^*:NOTICE:*:#:{ if ($nick !isreg #) { echo $color(notice) # $+(-,$nick(#,$nick).pnick,:,#,-) $1- | halt }  | halt }
on ^*:ACTION:*:#:{ if ($nick !isreg #) { echo $color(action) # * $nick(#,$nick).pnick $1- | halt }  | halt }
;on 1:KICK:*:{ if (($nick == $me) && ($knick != $me)) {
;if ($window(@Kick) == $null) { window -ekl10 @Kick 100 1 350 140 }
;echo @kick * $gettok($strip($4),1,34) : $timestamp : $chan : $address
;aline -l @Kick $knick
;}
;}
;on *:kick:#:{ 
  ;.hadd -mu30 count $nick $chan | .hinc -mu30 $chan $nick | .timer $+ $chan -o 1 20 .sockwrite -n * privmsg %soc.enter $counter($chan)
  ;if ($nick == $me ) { hinc -mu30 k z }
;}
;on ^*:ban:#:{ .hadd -mu30 count2 $nick $chan | .hinc -mu30 $+($chan,2) $nick | .timer $+ $+($chan,2) -o 1 20 .sockwrite -n * privmsg %soc.enter $counter2($+($chan,2)) }
alias -l counter {
  var %x 1
  while %x <= $hget(count,0).item { var %zx = %zx 4,0 $hget($1,%x).item : $hget($1,$hget($1,%x).item)  4™ | inc %x 1 }
  return 4™ 4,0 KICK COUNTER  4™ %zx 12M8y4RI3C 14v1.7c 4™
}
alias -l counter2 {
  var %x2 1
  while %x2 <= $hget(count2,0).item { var %zx2 = %zx2 12,0 $hget($1,%x2).item : $hget($1,$hget($1,%x2).item)  12™ | inc %x2 1 }
  return 12™ 12,0 BAN COUNTER  12™ %zx2 12M8y4RI3C 14v1.7c 12™
}
raw *:*: { if ($regex($numeric,/(367|368|401|441|478|482))) { halt } }

menu menubar,channel {
  MyRÏ¢ ßøt
  .Set #: set %soc.enter #
  .Set Other: if (!%soc.enter) { set %soc.enter $$?="Please Enter Channel Name !!!" } | else { echo -a * Previous : %soc.enter Had Been Set %logo | set %soc.enter $$?="Please Enter New Channel Name !!!" }
  .-
  .$iif($server,Check Bot)
  ..MyRIC II:echo -a 4» MyRIC-II $iif($sock(MyRIC-II).status,Online,Offline) 4« %logo
  ..MyRIC III:echo -a 4» MyRIC-III $iif($sock(MyRIC-III).status,Online,Offline) 4« %logo
  ..-
  ..Both:echo -a 4» [[ MyRIC-II : $iif($sock(MyRIC-II).status,Online,Offline) ][ MyRIC-III : $iif($sock(MyRIC-III).status,Online,Offline) ]] 4« %logo
  .$iif($server,Load Bot)
  ..MyRIC II:$iif(!$sock(MyRIC-II).status,MyRIC-II,echo -a 4» MyRIC-II Still Online 4« %logo)
  ..MyRIC III:$iif(!$sock(MyRIC-III).status,MyRIC-III,echo -a 4» MyRIC-III Still Online 4« %logo)
  ..-
  ..Both:{ $iif(!$sock(MyRIC-II).status,MyRIC-II,echo -a 4» MyRIC-II Still Online 4« %logo) | $iif(!$sock(MyRIC-III).status,MyRIC-III,echo -a 4» MyRIC-III Still Online 4« %logo) }
  .$iif($server,Kill Bot)
  ..MyRIC II:.sockwrite -n MyRIC-II quit %logo
  ..MyRIC III:.sockwrite -n MyRIC-III quit %logo
  ..-
  ..Both:.sockwrite -n * quit %logo
  .-
  .$iif($server,Join):.sockwrite -n * join %soc.enter
  .$iif($server,Part):.sockwrite -n * part %soc.enter
  .$iif($server,Say):.sockwrite -n * privmsg %soc.enter $$?="What To Say ?"
  .-
  -
  $iif($server,Ping):.timer 0 60 pang
}
menu @MyRIC-II {
  Clear:.clear 
  -
  Check: if ($sock(MyRIC-II).status != active) { window @MyRIC-II | .echo @MyRIC-II 4» MyRIC-II Offline 4« %logo } | else { window @MyRIC-II | .echo @MyRIC-II 4» MyRIC-II Still Active 4« %logo }
  Load: if ($sock(MyRIC-II).status != active) { window @MyRIC-II | .echo @MyRIC-II 4» Connecting MyRIC-II... 4« %logo | MyRIC-II | return } | else { window @MyRIC-II | .echo @MyRIC-II 4» MyRIC-II Still Active 4« %logo | return } 
  Kill:.sockclose MyRIC-II
  -
  Close:.window -c $active
}
menu @MyRIC-III {
  Clear:.clear 
  -
  Check: if ($sock(MyRIC-III).status != active) { window @MyRIC-III | .echo @MyRIC-III 4» MyRIC-III Offline 4« %logo } | else { window @MyRIC-III | .echo @MyRIC-III 4» MyRIC-III Still Active 4« %logo }
  Load: if ($sock(MyRIC-III).status != active) { window @MyRIC-III | .echo @MyRIC-III 4» Connecting MyRIC-III... 4« %logo | MyRIC-III | return } | else { window @MyRIC-III | .echo @MyRIC-III 4» MyRIC-III Still Active 4« %logo | return }
  Kill:.sockclose MyRIC-III
  -
  Close:.window -c $active
}
menu @Kick {
  Clear:.clear 
  -
  Del:.dline -l @kick $active
  -
  Close:.window -c $active
}
;* MessingAussey has quit IRC (Kill by OperServ (You are banned from this network: You and/or your "Team" or "Crew" are FORBIDDEN to be on this network due to repeated and constant abuse of WebChat Staff and the WebChat Network! (ID: /ZgEgAy0El4PBhQH^)))
