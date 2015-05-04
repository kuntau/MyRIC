ctcp !*:*:#: { if ($nick isreg #) { kc faulty ctcp } } 
on !*:ctcpreply:*:{ if ($nick isreg #) { kc faulty ctcpreply } } 
on ^*:text:*:#: { if ($nick isreg #) { $rgx($1-) } }
on ^*:notice:*:#: { if ($nick isreg #) { $rgx($1-) } }
on ^*:action:*:#: { if ($nick isreg #) { $rgx($1-) } }
on 1:signal:prö.arm:{ hinc -mu5 prö $+($1,$2-) | hinc -mu5 prö $1 }
alias -l rgx {
  if ($regex($1-,/(?:[[:cntrl:]])/g) > 49) { kc excessive cntrl | halt }
  else {
    var %s = $strip($1-)
    if ($regex(%s,/(?:#.|www\.|\.com|\.co\.)/g)) { kc advertising word | halt }
    if ($regex(%s,/(?:dick|shit|fuck|sial|pantat|babi|zakar|terbabit)/g)) { kc taboo word | halt }
    if ($regex(%s,/(?:[[:upper:]])/g) > 49) { kc excessive upper | halt }
    if ($regex(%s,/(?:[[:digit:]])/g) > 49) { kc excessive digit | halt }
    if ($regex(%s,/(?:[[:punct:]])/g) > 49) { kc excessive punct | halt }
    if ($regex(%s,/(?:\,)/g) > 49) { kc excessive comma | halt }
    if ($regex(%s,/(?: )/g) > 49) { kc excessive blank | halt }
    if ($regex(%s,/(?:[€-Ÿ¡-ÿ])/g) > 49) { kc excessive ascii | halt }
    if ($regex(%s,/(?:.)/g) > 199) { kc excessive charc | halt }
    ;if (!$regex(%s,/(?:terbabit|zakaria|mashitah|dickson)/g) && $regex(%s,/(?:dick|shit|fuck|sial|pantat|babi|zakar|terbabit)/g)) { kc taboo word | halt }
    var %n = $hash($nick,32), %t = $hash($remove(%s,$chr(32),$chr(160)),32)
    .signal -n prö.arm %n %t
    if ($hget(prö,$+(%n,%t)) > 2) { kc over repeat | halt }
    if ($hget(prö,%n) > 4) { kc over row | halt }
  }
}
;replace echo -a [w] kick $hget(prö,ni) $hget(prö,ch)
alias -l kc {
  ;if (!$kl) { echo -a Over Limit $hget(prö,kl) | halt }
  ;echo -a kick #Kuntau $anick 4,4 0,14 $1- 4,4 0,14 nForce 2 4,4 
  .kick # $nick 14" $1- is not allowed here " 4PLEASE RESPECT OUR RULES !!! 12My4R8I3C 14v1.7a

}
alias -l kl { if ($hget(prö,kl) < 19 || !$hget(prö,kl)) { hinc -mu30 prö kl 1 | $iif($hget(prö,kl) < 19,return 1) } }
alias -l kr { goto $r(0,1) | :0 | return 1 | :1 | return 1 }
alias -l kb { }
;e 14"excessive character is not allowed here" 4PLEASE RESPECT OUR RULES !!! 12My4R8I3C 14v1.7a
