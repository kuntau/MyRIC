#kuntau on
on *:kick:#:{
  If ($regex($knick,/MyRIC/)) {
    .timerwar -mc 1 5 sockwrite -tn myric kick # $hget(w,x) %d
    .sockwrite -tn myric join $chan
    ;warc
    if (!$regex($level($nick),/25/)) { rlevel 25 | auser 25 $nick | hadd -m w x $nick }
  } 
  if ($regex($nick,/MyRIC/)) { .timerwar -mc 1 50 sockwrite -tn myric kick # $hget(w,x) %p }
  else { return }
}
;on 25:join:#:{ .sockwrite -tn myric kick # $nick x4jx %d. | halt }
;on 100:join:#:{ .sockwrite -tn myric kick # $hget(w,x) x4ax %o | halt }
on ^*:join:#: { $iif($regex($level($nick),/(100|25)/),.timerwar -mc 1 00000 sockwrite -tn myric kick # $hget(w,x) %o) | halt }
;on *:op:#: { $iif($regex($level($opnick),/(100|25)/),.sockwrite -tn myric kick # $hget(w,x) %p) }
;on 100:op:#:{ $iif($hget(w,x) ison #,.sockwrite -tn myric kick # $hget(w,x) x4ox %neo,return) }
;on 25:op:#:{ .sockwrite -tn myric kick # $hget(w,x) x4zx %d | halt }
alias -l :k { .sockwrite -tn myric kick $chan $nick %neo }
raw *:*: { if ($regex($numeric,/(001|002|003|004|005|006|007|008|009|250|251|252|253|254|255|265|266|353|366|333|329|366|367|368|372|302|375|376|401|441|442|478|482|494)/)) { halt } }
on *:deop:{ if ($regex($level($opnick),/(100)/) { mode # +o $opnick } }
on *:signal:w:{ .hadd -m w x $1 | .auser 25 $1 }
;on *:quit:{ if ($nick == %s.nick) { f4 } }

on *:UNOTIFY:{ echo -a !@*&^!*@^^TY $1- | timersockopen 1 1 f4 }
on *:NOTIFY:{ .sockwrite -tn myric privmsg nickserv identify myric nsm1984 | warc }
alias f9 sockwrite -tn myric kick # $hget(w,x) x4xx %neo
alias war { .hadd -m w x $1 | .auser 25 $1 }
alias warc {
  ;.halt
  .timerwar -mc 2 160 sockwrite -tn myric kick #butuh $hget(w,x) x4cx %neo
  .timerrej -mc 1 150 sockwrite -tn myric join #butuh
}
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
