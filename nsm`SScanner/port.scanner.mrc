;on *:CONNECT:cariport
alias -l fpi return ( Fastest Proxy )
alias cariport {
  sockclose fp.*
  var %count = 1
  unset %§.fp.one %§.fp.ticks %§.fp.file
  set %§.fp.ticks $ticks
  set %§.fp.file $1
  echo -s $fpi Detecting the fastest proxy on 4 $+ $1 $+  ...
  while ($lines($1) >= %count) {
    var %read = $read($1,%count), %iptoscan = $gettok(%read,1,58), %porttoscan = $gettok(%read,2,58)
    if (!%iptoscan) { echo -s $fpi Null server detecting | halt }
    sockopen fp. $+ %count %iptoscan %porttoscan
    inc %count
  }
}
on *:sockopen:fp.*:{
  if ($sockerr) return
  if (%§.fp.one) goto end
  else {
    ;echo -s (ELSE) :: $sockname :: $sock($sockname).ip ::: $sock($sockname).port
    var %sname = $sockname, %snum = $gettok(%sname,2,$asc(.)), %port = $gettok(%§.fp.file,2,%snum)
    var %thetime = $calc(($ticks - %§.fp.ticks) / 1000) $+ ms
    ;if (%§.fp.one == $port) echo -s $fpi You are currently using the fastest port on this server. 
    ;else echo -s $fpi Fastest proxy for server $server is ::: $read(%§.fp.file,%snum) ::: dengan kelajuan ( $+ %thetime $+ )
    echo -s $fpi For server $server is 4/firewall on $sock(%sname).ip $sock(%sname).port $+  with speed ( $+ %thetime $+ )
  }
  :end 
  sockclose $sockname
}
