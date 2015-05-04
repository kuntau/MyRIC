on *:connect:{ away "Copy from one, it's plagiarism; copy from two, it's research." }

on !*:ctcpreply:ping*: { if ($nick == $gettok(%lag,1,32)) { msg $active 13 $+ $nick reply: $calc(($ticks - $gettok(%lag,2,32)) / 1000) sec(s) | unset %lag } }

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
