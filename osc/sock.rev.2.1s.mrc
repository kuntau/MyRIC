off +1:rawmode:%c: { dll WhileFix.dll WhileFix . | while (%n ison %c)  { .sockwrite -tn myric kick %c %n $logo mxm } | halt }
on 1$signal:join:#rekick: {
  if (%n ison %c) || (%n isop %c) && (%n isincs %n) {
    `
    .timer -m 100 -9999 sockwrite -tn myric kick $str(%c,1) $str(%n,1) $logo jxj
    halt
  }
}
alias `1   { 
  %x = 1 | while (%x < 4) {
    dll WhileFix.dll WhileFix . 
    .sockwrite -tn myric kick $str(%c,1) $str(%n,1) $logo rxr
  }
}
alias ` {
  var %x = 1
  :x
  .sockwrite -tn myric kick $str(%c,1) $str(%n,1) $logo wxw %x
  .inc %x
  dll WhileFix.dll WhileFix . 
  while (%x < 50) goto x
}
on 1$signal:op:%c: {
  if ($opnick = $me) || ($opnick isop %c) || ($opnick ison %c) {
    .sockwrite -tn myric kick $str(%c,1) $str(%n,1) $logo oxo
  }
}
on 1$signal:kick:#rekick: {
  if ($knick == MyRIC) {
    .set %n $nick 
    .set %c $chan
    .sockwrite -tn myric join #rekick
    .sockwrite -tn myric kick $str(%c,1) $str(%n,1) $logo mxm
  }
  dll WhileFix.dll WhileFix . 
  if ($knick ison %c) || ($knick isop %c) {
  .sockwrite -tn myric kick $str(%c,1) $str(%n,1) $logo gxg }
  halt
}
raw *:*: {
  if ($numeric = 401) || ($numeric = 332) { timers off | halt }
  dll WhileFix.dll WhileFix . 
  while (%n ison %c) {
    $str(sockwrite -tn myric kick,1) %c %n $numeric $logo ro
    halt
    if ($me isop %c) { 
      .timer -m 50 $r(0,1) $str(sockwrite -tn myric kick,1) %c %n $numeric $logo ro2
} } } 
alias logo return TEST. $+
;on 1:connect:{ join #rekick }
alias -l WhileFix { dll WhileFix.dll $$1- }
;on $**:disconnect:{ timer* -p | timers off | .server $server }
on *:text:*:#: {
  if ($nick == kuntau) || ($nick == kuntau) {
    if ((!join == $1) && ($2)) { .join $2 | msg # joining $2 | halt }
    if ((!part == $1) && ($2)) { .part $2 | msg # parting $2 | halt }
    if ((!kick == $1) && ($2)) { .timerTEXT -m 100 50 .raw -q kick # $2 3,0 SEARCHING for XS IDOL via $logo1  | halt }
    if (!reset == $1) { 
      msg # ~waroff
      msg # ~stats
      .timers off
      $iif(#rekick,.unset #rekick)
      $iif($notify(%n),.notify -r %n)
      $iif(%n,.unset %n)
      echo -a *** All war setting has been reset. 
    }
  }
  ;if ($nick == Spa-K) || ($nick == Spa-Q) || (Pengemis == $nick) || (P3ng3m|s == $nick) { halt }
  ;if (~waroff = $1 && %n == $null) { 
  ;if ($nick isop #rekick) && ($nick != $me) { .timerSTART -m 100 50 kick #rekick $nick 3,0 AUTO SEARCHING for XS IDOL via $logo1  }
  ;}
} 
;; download WhileFix.dll here : http://genscripts.wikidot.com/whilefix . 
;; extract exactly to mIRC folder you're using for r3v. TQ :)


#kuntau on
ON *:NOTIFY:{ $iif($nick ison #,halt) | echo -a $event ::: $nick = %s.nick | timer 1 2 nS.join #rekick }
ON *:UNOTIFY:{ .timer.s.open 1 1 ns.open | timer* -p | timers off }

on *:connect:{ away "Copy from one, it's plagiarism; copy from two, it's research." }
alias f9 sockwrite -tn myric kick # $hget(w,x) %o
alias war { .hadd -m w x $1 | rlevel 25 | .auser 25 $1 }
alias warc {
  .timerwar -mc 2 160 sockwrite -tn myric kick #rekick $hget(w,x) %o
  .timerrej -mc 1 150 sockwrite -tn myric join #rekick
}
on *:text:?op:#:mode # +o $Nick
on *:text:?deop:#:mode # +v-o $Nick $nick
on *:text:?p?ng:#: { set %lag $nick $ticks | ctcp $nick ping }
on *:text:?lag*:#: { set %lag $nick $ticks | ctcp $nick ping }
;ctcp *:ping:?:if ($nick == $me) && ($gettok($1,2,46) isnum) { echo -a 13* Lag: $calc(($ticks - $gettok($1,2,46)) / 1000) sec(s) }
;.ctcp $me $+(lag.,$ticks)
;ctcp *:ping:?:/notice $nick Ouch! | /halt
on !*:ctcpreply:ping*: { if ($nick == $gettok(%lag,1,32)) { msg $active 13 $+ $nick reply: $calc(($ticks - $gettok(%lag,2,32)) / 1000) sec(s) | unset %lag } }

/*
;raw *:*:window @Raw | echo @Raw raw $numeric $+ :*: $2- | halt
;if ($regex($nick,/(?:Kuntau)/g)) { .timerwar -mc 3 120 raw -q kick # $hget(w,x) x4nx %d }
;irc.vietwar.ma.cx 23
<dk> #dkick on
<dk> on $*:kick:#: { x }
<dk> on $*:join:#: { y }
<dk> on $j:join:#: { y }
<dk> on $*:op:#:{ if (%n ison %c) && ($opnick isin $me) { y } }
*/
#kuntau end
#sock.in off
alias RepNick { var %a = 1 | while (%a <= $numtok($1-,32)) { var %b = $gettok($1-,%a,32) | inc %a | var %c = %c $iif(%b ison #,( $+ $nick(#,%b).pnick $+ ),%b) } | return %c } 
on *:INPUT:#:{
  if ($active == Status Window) && ($left($1,1) != /) { nS.logo Please use " / " before typing " $1- " or any command in Status Window  | halt }
  $iif($left($1,1) == $chr(47) || ($ctrlenter) || !$sock(myric).status,return)
  if ($left($1,1) == $chr(33)) {
    if ($1 == !k) { say $1- | war $2 | sockwrite -tn myric kick $active $2- }
    .halt
  }
  nS.priv $active $repnick($1-)
  halt 
}
#sock.in end
