;sock counter
alias sc.count { sockopen MyRIC irc.banjir.info 7000 }
alias sc.join { .sockwrite -nt MyRIC join $1 }
alias sc.s { .sockwrite -tn myric privmsg # $1- }
on 1:sockopen:myric:{
  if ($sockerr > 0) { .sockclose $sockname | return } 
  .sockwrite -tn $sockname user MyRIC 2 3 : 12M8y4RI3C 4: 15Counter
  .sockwrite -tn $sockname nick MyRIC[counter]
  ;.timerlove -o 0 30 .sockwrite -tn myric privmsg $!active $!.q
  .halt
}
alias .q { .sockwrite -tn myric privmsg $active  $+ $r(00,15) $+ $read(loves.txt) eXpressions. }
on 1:sockread:myric:{ 
  if ($sockerr > 0) { return } 
  :semula 
  .sockread %s.re
  if (!$sockbr) { return } 
  if (!%s.re) { goto semula } 
  if ($mid(%s.re,1,4) == PING) { .sockwrite -tn $sockname PONG $remove($remove(%s.re,ping :),ping) | halt } 
  ;echo @myric 4[EYE] %s.re
  var %c = $gettok(%s.re,3,32), %n = $gettok($gettok(%s.re,1,58),1,33), %m = $gettok(%s.re,2,32), %x = $strip($gettok(%s.re,4,32))
  $iif(%m == MODE && b isincs %x && $left(%x,1) == $chr(43),.signal -n sc.ban %c %n %x,$iif(%m == KICK,.signal -n sc.kick %c %n,halt))
  ; .signal -n $gettok(%s.re,3,32) $gettok($gettok(%s.re,1,58),1,33) $gettok(%s.re,2,32)
  ;if ($gettok($gettok(%s.re,1,58),1,33) !isreg $gettok(%s.re,3,32)) { halt }
}
;on *:ban:#:{ .hinc -mu30 ban $nick | .timer $+ $nick -o 1 12 .sockwrite -tn myric privmsg # $sc.out(#,$nick) | .timerlove -o 1 15 $!.q }
;on *:kick:#:{ .hinc -mu30 kick $nick | .timer $+ $nick -o 1 12 .sockwrite -tn myric privmsg # $sc.out(#,$nick) }
;on ^*:quit:{ if (Excess isin $1) { .hinc -mu30 nxs $nick | .timernxs $+ $nick 1 10 .sockwrite -tn myric privmsg # 6• 3XS FLOOD 6• $nick(#,$nick).pnick 6• 1 6• } }
alias sc.out {
  .return 6• 7COUNTER 6• $2 6• 4KICK 6• $iif($hget(kick,$2),$ifmatch,$null) 6• 12BAN 6• $iif($hget(ban,$2),$ifmatch,$null) 6•
}
on *:signal:sc.ban: {
  ;echo @myric $1-
  ;$iif(b !isincs $3,return)
  .hinc -mu30 ban $2 $count($3,b)
  .timer $+ $2 -o 1 12 .sockwrite -tn myric privmsg $1 $sc.out($1,$2) 
  .timerlove -o 1 15 $!.q
}
on *:signal:sc.kick: {
  .hinc -mu30 kick $2 
  .timer $+ $2 -o 1 12 .sockwrite -tn myric privmsg $1 $sc.out($1,$2)
}
#inpuk on
on *:INPUT:*:{
  ;if ($active == Status Window) && ($left($1,1) != /) { echo -s *** Please use " / " before typing any command in Status Window  | halt }
  $iif($left($1,1) == $chr(47) || ($ctrlenter),return)
  ;else { var %i = $1-, %i0 = 1 | while (%i0 <= $hget(input,0).item) { var %i1 = $hget(input,%i0).item | while ($istok(%i,%i1,32)) { %i = $reptok(%i,%i1,$hinput($strip($h.(input,%i1))),1,32) } | inc %i0 } | msg $active $repnick(%i) | halt } 
  sockwrite -tn myric privmsg $active $eval($1- ,2)
  halt 
}
#inpuk end
