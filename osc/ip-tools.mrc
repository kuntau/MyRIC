on 1:signal:dll.:/dll WhileFix.dll WhileFix .
;generate ip in file with range and port
alias ip.gen {
  var %z1 = $gettok($1,4,46), %z2 = $gettok($2,4,46), %zip
  echo -a $1- *** %z1 *** %z2
  write -c store.txt
  while (%z2 > %z1) {
    .signal -n dll.
    %zip = $+($gettok($1,1-3,46),$chr(46),%z1,$chr(58),$3)
    write store.txt %zip
    inc %z1
  }
  echo -ea Job finished
}
alias ip.gen2 {
  var %:ip = $1, %:p = $2, %:c = 1, %zip
  echo -a $1- ::: %:ip %:p
  write -c gen.txt
  while (255 >= %:c) {
    .signal -n dll.
    %zip = $+($replace(%:ip,$chr(42),%:c),$chr(58),%:p)
    write gen.txt %zip
    inc %:c
  }
  echo -ea Job finished
}
;remove 2nd token ":" a.k.a port
alias ip.rem {
  echo 15 -a $fpi Token removal tools: From 13" $+ $1 $+ 13"
  var %lines = $lines($1), %count = 1, %out $2, %cur
  write -c %out
  while (%count <= %lines) {
    .signal -n dll.
    write %out $deltok($read($1,%count),2-,58)
    inc %count
  }
  echo 15 -a $fpi Token removal tools: Finish To 13" $+ $2 $+ 13"
  run $mircdir
}
;ip rem2
;FORMAT: ip.rem2 <source file> <output file> <token> <range>
alias ip.rem2 {
  echo 15 -a $fpi Token removal tools with range: From 13" $+ $1 $+ 13" Token 13( $3 13) Range 13( $4 13) 
  var %lines = $lines($1), %count = 1, %out $2, %cur
  write -c %out
  while (%count <= %lines) {
    .signal -n dll.
    write %out $deltok($read($1,%count),$4,$3)
    inc %count
  }
  echo 15 -a $fpi Token removal tools: Finish To 13" $+ $2 $+ 13"
  ;run $mircdir
}
;ip replace token
alias ip.rep {
  echo 15 -a $fpi Token 13( $3 13) removal tools: From 13" $+ $1 $+ 13"
  var %lines = $lines($1), %count = 1, %out $2, %cur
  write -c %out
  while (%count <= %lines) {
    .signal -n dll.
    write %out $reptok($read($1,%count),$gettok($read($1,%count),1,32),POST,$3)
    inc %count
  }
  echo 15 -a $fpi Token removal tools: Finish To 13" $+ $2 $+ 13"
  ;run $mircdir
}
;rem junk
alias rem.junk {
  echo 15 -a $fpi Junk removal tools: From 13" $+ $1 $+ 13" $lines($1) Line(s)
  var %lines = $lines($1), %count = 1, %out $2, %cur
  write -c %out
  while (%count <= %lines) {
    .signal -n dll.
    write %out $deltok($read($1,%count),2,58)
    ;write %out $deltok($read($1,%count),2-,32)
    ;/write %out $deltok($read($1,%count),1,44)
    ;if ($left($read($1,%count),1) == $chr(47)) { write %out $read($1,%count) }
    ;echo -a ::: $left($read($1,%count),1  :::: $1-
    inc %count
  }
  echo 15 -a $fpi Junk removal tools: Finish To 13" $+ $2 $+ 13"
}
alias -l fpi return 13( IP Tools 13)
alias fproxy {
  sockclose fp.*
  var %count = 1
  unset %.fp.ticks %.fp.file
  set %.fp.ticks $ticks
  set %.fp.file $iif($1,$1,fport.txt)
  $iif(!$window(@fProxy),window -ke @fProxy)
  write -c fProxyOpened.txt
  echo @fproxy $fpi Detecting the fastest proxy on 4 $+ %.fp.file $+  with 4 $+ $lines(%.fp.file) $+  line(s) ...
  while ($lines(%.fp.file) >= %count) {
    .signal -n dll.
    var %read = $read(%.fp.file,%count), %iptoscan = $gettok(%read,1,58), %porttoscan = $gettok(%read,2,58)
    if (!%iptoscan) { echo -s $fpi Null server detecting | halt }
    sockopen fp. $+ %count %iptoscan %porttoscan
    inc %count
  }
  echo @fproxy $fpi Sockopen job on file 4 $+ %.fp.file $+  with 4 $+ $lines(%.fp.file) $+  line(s) finished ...
}
on *:sockopen:fp.*:{
  if ($sockerr) return
  if (%.fp.one) goto end
  else {
    var %sname = $sockname, %snum = $gettok(%sname,2,$asc(.)), %port = $gettok(%.fp.file,2,%snum), %thetime = $calc(($ticks - %.fp.ticks) / 1000) $+ ms
    write fProxyOpened.txt $sock(%sname).ip $+ : $+ $sock(%sname).port
    echo @fproxy $fpi Sockname 4 $+ $sockname $+  : 4/firewall on $sock(%sname).ip $sock(%sname).port $+  with speed 4( $+ %thetime $+ ) 
  }
  :end 
  sockclose $sockname
}
menu @fProxy {
  fProxy: fproxy
  fProxy gen.txt: fproxy gen.txt
  -
  sockclose fp.* : sockclose fp.*
  -
  Open fport.txt:run fport.txt
}
cn.gen {
  var %len = $len($1), %count = 1, %text
  while (%len) {
    %text = 
    dec %len
  }
  echo -a %text
}
