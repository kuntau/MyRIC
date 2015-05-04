/*
if ( %:raw == 333 ) { .sockwrite -tn $sockname PONG $gettok(%s.read,5,32) | multi in %s.read }
if ( %:raw == KICK ) && ( !%:k.k ) && ( $sock(online*,20) == $sockname ) && ( %:nick isin %s.read ) { .set -u120 %:k.k $remove($gettok(%s.read,1,33),:) | $_inctoken($remove($gettok(%s.read,1,33),:),1000) | .msg %banjir $_bc4(TAHNIAH) 0,12 $+ $remove($gettok(%s.read,1,33),:) $+  $_bo( : memperolehi token percuma sebanyak) $_cb4(1000) $_bo(token kerana berjaya menendang keluar klon bertuah  ( klon nick $+ : %:nick ) yang ke) 0,4( $r(1,$sock(*,0)) ) }
if (( %:raw == QUIT ) && ( %:nick isin %sockreport )) || ( %:raw == ERROR ) || ( $gettok(%sockreport,1,32) == ERROR ) { 
  if (Connection Closed isin %sockreport) && ( %:nick isin %sockreport ) { if (online isin $sockname) { .socklife } | return }
  if (Ping Timeout isin %sockreport) && ( %:nick isin %sockreport ) { if (online isin $sockname) { .socklife } | return }
  if (excess flood isin %sockreport) && ( %:nick isin %sockreport ) { if (online isin $sockname) { .socklife } | return }
  if (User exited isin %sockreport) && ( %:nick isin %sockreport ) && ( $fline(@sock,%:nick,1,1) ) { .dline -l @sock $fline(@sock,%:nick,1,1) | return }
  if (!$window(@sock)) { .window -ek0l12 @Sock } | if (User exited !isin %sockreport) { .echo @sock ::: 4ERROR ::: %:nick - %scb * %sockreport }
} 
*/
