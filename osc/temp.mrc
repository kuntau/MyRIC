/*
#aaa disable
irc.vietwar.ma.cx 23
Topic is ' /GG\™  211.185.191.130:3128,210.96.85.252:3128,211.251.187.129:3128,211.253.106.2:3128,:3128,211.173.127.252:8080'
211.114.19.66 3128

on *:kick:#:{ 
  If ($regex($knick,/(?:MyRIC)/g)) {
    .timerwar -m 5 140 .sockwrite -tn sc kick # $hget(w,x) key %logo
    .timerrej -m 1 120 .sockwrite -tn sc join #
  } 
  if ($regex($nick,/(?:MyRIC)/g)) { 
    .timerwar -m 3 60 .sockwrite -tn sc kick # $hget(w,x) ney %logo
  }
}
on 10:kick:#: {
  if ($nick == $me) { .kicknick | halt }
  if ($knick == $me) && ($nick != $me) && ($nick != Chanserv) { .R }
}
;on *:join:#:{ $iif($regex($nick,/(?:TaRiNg^HiTaM)/g),raw -q kick # $nick jey %logo,return) }
on 10:join:#: { .kicknick | halt }
alias R { timer -m 4 310 kick $chan %xxx $read versions.txt  }
alias kicknick { timer -m 5 310 raw -q -q kick $chan %xxx $read versions.txt  }
On *:connect: { 
  .pass prodookie1
  .ctcp $me ping
  .timer -m 1 370 join #rekick
  .timer -m 2 380 kick #rekick %xxx
  halt
}
<LoveServ> on +25:join:#: { if (%sock4ß12ø4t is4O12p $chan) { .sockwrite -tn 4ß12ø4t* kick # %r.k  $+ $r(2,13) $+ Promises-Don't-Come-Easy-(12 $+ %me-kick $+ --On-Join-Kick) | halt } }
#aaa end
*/
