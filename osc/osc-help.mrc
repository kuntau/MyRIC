on 1:sockopen:*:{
  if ($sockerr > 0) { .sockclose $sockname | return }
  .echo -a 4» Connecting $sockname $+ ... 4« %logo
  .sockwrite -tn $sockname user $sockname 2 3 : test jer 4: $sockname
  .sockwrite -tn $sockname nick MyRIC
}
alias clone { 
  .set %bot.sock clone $+ $r(0001,1000) 
  sockopen %bot.sock irc.vietwar.ma.cx 23
}
