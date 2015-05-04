alias check.lag { $iif(!$server,return) | .ctcp $me $+(lag.,$ticks) }
ctcp *:lag.*:?:if ($nick == $me) && ($gettok($1,2,46) isnum) { echo -a 13* Lag: $calc(($ticks - $gettok($1,2,46)) / 1000) sec(s) }
on *:INPUT:#:{
  if ($active == Status Window) && ($left($1,1) != /) { er.h Please use " / " before typing any command in Status Window  | halt }
  if ($left($1,1) == /) { return }
  ;if ($1 ison $chan) && ($ctrlenter) { $iif($2,msg $active  ::: $tr($1) ::: $2-,msg $active  ::: $tr($1) :::) | halt }
  if ($ctrlenter) { ns.priv # $1- | halt }
  ;else { ctcp angelkicker msg # $1- | halt }
}
on *:connect:{
  if (*freenode* iswm $server) {
    .join #cakephp
    .join #jquery
    .join #coffeescript
    .join #node.js
    ;.join #phpmyadmin
  }
}
