;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                       INFO                       ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

/*
* Script name: tE.user.1.0.mrc
* Author: Kuntau
* Contact: admin@kuntau.net
* Website: http://kuntau.net/
* Date: 28 August 2008
* Version: 1.0 (delay)
* Purpose: Banjir detection using DLL
* Usage: Keep the remote & the DLL in the SAME directory
*/

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                        DCC                      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on 1:connect:{ .window -h @dxz | .debug -ipt @dxz dxz | .window -h @dxz }
on *:CLOSE:@x*:{ .debug -i NUL dxz  }
alias dxz { if ($regex($1, /^<- :([^!]*)![^@]*@[^ ]*\s*PRIVMSG\s*(\S*)\s*:\001\s*DCC\s*(SEND|RESUME).*"(?:[^" ]*\s){32}.*$/i)) { -k $regml(2) $regml(1) ipkpkyudcci } | halt }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                    MAIN.EVENT                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on !*:ctcpreply:*: { if ($nick isreg $chan) -k # $nick $event | halt }
ctcp !*:*:*: { if ($nick isreg $chan) -k # $nick $event | halt }
on ^*:text:*:#: { if ($nick isreg $chan) { $dll.detect($1-) | halt } }
on ^*:notice:*:#: { if ($nick isreg $chan) { $dll.detect($1-) | halt  } }
on ^*:action:*:#: { if ($nick isreg $chan) { $dll.detect($1-) | halt  } }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                   DETECTION                      ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias -l dll.detect { if ( $dll(banjirDLL.dll, Auto, $1-) ) -k $chan $nick $ifmatch | var %hash.nick = $hash($address($nick,0),32), %hash.text = $hash($remove($1-,$chr(32), ),32) | hinc -mu2 dll.hash %hash.nick $+ %hash.text | hinc -mu2 dll.hash %hash.nick | if ($hget(dll.hash,$+(%hash.nick,%hash.text)) = 3) -k $chan $nick repeat | if ($hget(dll.hash,%hash.nick) = 5) -k $chan $nick flood }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                    ALIAS.KICK                    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias -l -k {
  .inc -u10 %kxi 1 
  ;if (%kxi > 23) && (%kxi < 47) {
  if (%kxi < 24) {
    .sockwrite -tn myric kick $1- $+ : 15The13.15e13X15pression13.15v11 Mastering Edition.
    ;echo @notice kick.. 0,13sock close ::: $hget(delay,0).item ::: kxi = %kxi ::: reason = $1-
  }
}
alias -l -kx {
  .inc -u10 %kxi 1 
  hadd -m delay %kxi $1-
  if (%kxi isnum 1-20) {
    .sockwrite -tn myric kick $1- $+ : 15The13.15e13X15pression13.15v11 Mastering Edition.
  }
  if (%kxi = 20) {
    set %delay.kicked 21
    set %sock.reboot 1
    sockwrite -tn myric part #
    nS.close
    .timersockrebootccheck -m 2 100 ns.open
    echo @notice msg #banjir 0,13sock close ::: $hget(delay,0).item ::: sr %sock.reboot : dk %delay.kicked
  }
  halt
}
alias sock.delay {
  if (%sock.reboot) {
    set %sock.reboot 0
    set %i 1
    ;msg #banjir 0,13back from reboot ::: $hget(delay,0).item :: rs: %sock.reboot
    while ($hget(delay,0).item > 0) && (%i < 19) {
      /tokenize 32 $hget(delay,%delay.kicked)
      if ($2 isreg $1) {
        .sockwrite -tn myric kick $1- $+ : %i $+ %delay.kicked 15The13.15e13X15pression13.15v11 Mastering Edition.
        ;echo @notice 12:::KICK::: kick $1- testing mode... i = %i * delay.kicked = %delay.kicked
        inc %i 1
      }
      if (%delay.kicked >= $hget(delay,0).item) || (%delay.quit >= 33) {
        .timerdelayclearance 1 5 delay.clear
        set %i 20
      }
      inc %delay.kicked 1
    }
    if (%i = 19) {
      echo @notice msg #banjir 7:::REBOOTING::: i = %i delay.kicked = %delay.kicked
      set %i 1
      set %sock.reboot 1
      nS.close
      inc %delay.quit 
      .timersockrebootccheck -m 2 200 ns.open
    }
  }
}
alias delay.clear { 
  echo @notice msg #banjir 11:::OVER::: i = %i d.k = %delay.kicked d.d = %delay.double
  set %delay.kicked 1
  set %delay.quit 0
  hfree delay
}
alias -l -k2 { halt }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                    ALIAS.BAN                     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

on 1:signal:dll.ban:{ 
  .hadd -u5m dll ban $addtok($hget(dll,ban),$+($2,!*@*101011*),32) 
  .timerb1 1 30 !.mode $1 $+(+,$str(b,12)) $gettok($hget(dll,ban),1-12,32) 
  .timerb2 1 32 !.mode $1 $+(+,$str(b,12)) $gettok($hget(dll,ban),13-24,32) 
}
on 1:signal:delay.ban:{
  var %bm = !*@*101101*
  timerb1 1 27 !.mode $1 $+(+,$str(b,12)) $+($hget(delay,1),%bm) $+($hget(delay,2),%bm) $+($hget(delay,3),%bm) $+($hget(delay,4),%bm) $+($hget(delay,5),%bm) $+($hget(delay,6),%bm) $+($hget(delay,7),%bm) $+($hget(delay,8),%bm) $+($hget(delay,9),%bm) $+($hget(delay,10),%bm) $+($hget(delay,11),%bm) $+($hget(delay,12),%bm)
}
alias fake.ban {
  if ($ial(#,0) > 45) { msg # IAL full! Camne nak ban? }
  .sockwrite -tn myric mode #banjir $str(b,12) $fake.nick.gen $fake.nick.gen $fake.nick.gen $fake.nick.gen $fake.nick.gen $fake.nick.gen $fake.nick.gen $fake.nick.gen $fake.nick.gen $fake.nick.gen $fake.nick.gen $fake.nick.gen
}
alias fake.nick.gen {
  return $r(A,Z) $+ $r(a,z) $+ $r(A,Z) $+ $r(1,9) $+ $r(A,Z) $+ $r(1,9) $+ $r(1,9) $+ $r(A,Z) $+ !*@*1001*10*
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                      MISC                        ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

raw *:*: { if ($regex($numeric,/(001|002|003|004|005|006|007|008|009|250|251|252|253|254|255|265|266|353|366|333|329|366|367|368|372|302|375|376|401|441|442|478|482|494))) { halt } }
raw 473:*: { .echo -a Error 3? 15 $+ $2 Is Invite Only | .msg chanserv invite $2 $1 | .timer 1 1 join $2 $1 | halt }
on ^*:KICK:#: { $iif($nick == MyRIC, return) | echo $chan * $knick was kicked by $nick ( $+ $left($strip($1-),60) $+ ) | halt }
on ^*:JOIN:#: { if ($nick != MyRIC) halt | mode $chan +o $nick | sock.delay | .halt }
;on ^*:JOIN:#: { .kill $nick suspect flooder | .halt }
on ^*:NICK: { .inc -u5 %halt.nick | $iif(%halt.nick > 5,halt,return) }
on ^*:PART:#: { .halt }
;on ^*:UNBAN:#: { .timerfakeban1 1 20 fake.ban | .halt }
on ^*:RAWMODE:#: { halt }

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;                  END.OF.SCRIPT                   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
