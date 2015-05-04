#kuntau on
on *:kick:#:{
  If ($regex($knick,/MyRIC/)) {
    $iif(!$regex($level($nick),/25/),.signal -n w $nick)
    .timerrekick -mc 2 60 sockwrite -tn myric kick # $hget(w,x) %o
    ;.timerrekick2 -mc 1 100 sockwrite -tn myric kick # $hget(w,x) %o 2
    ;.timerwarjoin -mc 1 1000 sockwrite -tn myric join $chan
    sockwrite -tn myric join $chan
    ;.dll WhileFix.dll WhileFix .
  } 
  if ($regex($nick,/MyRIC/)) { .timerwar -mc 1 50 sockwrite -tn myric kick # $hget(w,x) %o $+ TurboTimer  }
}
on ^*:join:#: {
  $iif($regex($level($nick),/(25|100)/),.timerwar -mc 1 000000 sockwrite -tn myric kick # $hget(w,x) %o)
  halt 
}
alias warx {
  $iif(myric !ison $active,.sockwrite -tn myric join $active)
  while (myric ison $active) {
    .sockwrite -tn myric kick $active $hget(w,x) test triple turbo
    ;$iif(myric !ison $active,.sockwrite -tn myric join $active)
    .dll WhileFix.dll WhileFix .
    ;.halt
  }
  halt
}
alias twarx { .timerwarxxxx -mc 0 0 warx }
;on ^*:join:#: { .scon -a $iif($regex($level($nick),/(25|100)/),.timerwar -mc 5 000 sockwrite -tn myric kick # $hget(w,x) %o) | halt }
;on ^25:join:#: { .timerwar -mc 1 000 sockwrite -tn myric kick # $nick %o | halt }
;on ^100:join:#: { .timerwar -mc 1 000 sockwrite -tn myric kick # $hget(w,x) %o | mode # +o $nick }
;on ^*:op:#: {
;$iif($regex($level($opnick),/25/),.timer -mc 5 000 sockwrite -tn myric kick # $nick %o) 
;$iif($regex($level($opnick),/100/),.sockwrite -tn myric kick # $hget(w,x) %o)
;}
;on *:op:#: { $iif($regex($level($opnick),/(100|25)/),.timer -mc 5 000 sockwrite -tn myric kick # $hget(w,x) %o) }
alias -l :k { .sockwrite -tn myric kick $chan $nick %neo }
raw *:*: { if ($regex($numeric,/(001|002|003|004|005|006|007|008|009|250|251|252|253|254|255|265|266|353|366|333|329|366|367|368|372|302|375|376|401|441|442|478|482|494)/)) { halt } }
on *:deop:{ if ($regex($level($opnick),/(100)/) { mode # +o $opnick } }
on *:signal:w:{ hadd -m w x $1 | rlevel 25 | auser 25 $1 }
;on *:quit:{ if ($nick == %s.nick) { f4 } }

on *:UNOTIFY:{ echo -a !@*&^!*@^^TY $1- | timersockopen -mc 1 500 f4 }
on *:NOTIFY:{ ;.sockwrite -tn myric privmsg nickserv identify myric nsm1984 | warc }
on *:connect:{ away "Copy from one, it's plagiarism; copy from two, it's research." | oss }
alias f9 sockwrite -tn myric kick # $hget(w,x) %o
alias war { .hadd -m w x $1 | rlevel 25 | .auser 25 $1 }
alias warc {
  ;.halt
  .timerwar -mc 2 160 sockwrite -tn myric kick #butuh $hget(w,x) %o
  .timerrej -mc 1 150 sockwrite -tn myric join #butuh
}
alias oss { ns identify K|ck nsm1984 | timer 1 1 os oper K|ck 753082 }

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
