on 1:start:set %s.s $server $port | set %show disable | set %logo 12My4R8I3C 15v0.02 ZeRo SeRiEs
alias scx { if (!$sock(sC).status) { .sockopen sC $server $port } }
on 1:sockopen:*:{
  if ($sockerr > 0) { .sockclose $sockname | return }
  .echo -a 4» Connecting $sockname $+ ... 4« %logo
  .sockwrite -tn $sockname user $sockname 2 3 : 12My4R8I3C 4: $sockname
  .sockwrite -tn $sockname nick MyRIC
  .sockwrite -tn $sockname ns identify myric nsm1984
}
;on 1:sockread:*:{
;  if ($sockerr > 0) return
;  :nextread
;  sockread %temp
;  if ($sockbr == 0) return
;  if (%temp == $null) %temp = -
;  ;echo 4 %temp
;  goto nextread
;}
on +25:op:#:{ .sockwrite -tn sc kick # $opnick ney %logo | halt }
on +100:op:#:{ .sockwrite -tn sc kick # $hget(w,x) mey %logo | halt }
on +100:kick:#:{ 
  If ($regex($knick,/(?:MyRIC)/g)) { .timerrej -m 1 120 .sockwrite -tn sc join # | .timerwar -m 5 140 .sockwrite -tn sc kick # $nick rey %logo | halt } 
  elseif ($regex($nick,/(?MyRIC)/g)) { .timerwar -m 5 60 .sockwrite -tn sc kick # $hget(w,x) zey %logo }
}
on +25:join:#: { if (MyRIC isop $chan) { .sockwrite -tn sc kick # $nick jey %logo | halt } }
on 1:connect:{ 
  .nick Kuntau
  .pass nsm1984 
  ;.timerwar -m 5 140 raw -q kick #rekick ReDz`tONe xcx 
  ;.timerrej -m 1 120 join #rekick 
}
alias f9 .sockwrite -tn sc join #rekick
alias sf9 .sockwrite -tn sc part #rekick
alias f10 .sockwrite -tn sc kick #rekick $hget(w,x) xey %logo
raw *:*: { if ($regex($numeric,/(001|002|003|004|005|006|007|008|009|250|251|252|253|254|255|265|266|353|366|333|329|367|368|372|302|375|376|401|441|442|478|482|494))) { halt } }
