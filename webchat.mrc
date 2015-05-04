; Web Chat Server en français, version 2.4 (c) Averell 2003-2004
; Système permettant de faire du chat irc temps réel en passant par une page web, sans applette java.
; Inspirateurs: Internet Chat Systems ( http://www.chatsystems.com ) dont j'ai rippé les codes html

; Testé sous mirc 6.03 (besoin de gérer les hash-tables et les expressions régulières)
; Testé avec Internet Explorer 6

on 1:socklisten:chatsys: webopen $sockname
on 1:sockread:web*:webread $sockname
on 1:sockclose:web*: closeweb $sockname
on 1:sockopen:irc*: ircopen $sockname
on 1:sockread:irc*: ircread $sockname
on 1:sockclose:irc*: closeirc $sockname

; identd stuff... Merci à DixRoue

on *:socklisten:identd:{ sockaccept $+(identd.,$ticks) | sockclose identd }
on *:sockread:identd.*:{ sockread %a | tokenize 32 %a | if ($numtok($1-,44) == 2) && ($+($1,$3) isnum) { sockwrite -n $sockname $3 , $1 :USERID:UNIX:WebChat | sockclose $sockname } | unset %a }

alias writeirc {
  if ($sock(irc $+ $1).name == $null) { return }
  sockwrite -n irc $+ $1 $2-

  %g = $asc($gettok($2-,2,32))
  if ( $2 == privmsg && %g != 35 && %g != 38 ) {
    aline -ph 2 @priv $+ $1 $2-
  }
  else {
    aline -ph 2 @chat $+ $1 $2-
  }

}

alias closeirc { 
  var %cook = $right($1,$calc($len($1)-3))

  println $1 0 <script> parent.fermetout(); alert(" $+ $liremess(53) $+ "); window.top.location.href="/"; </script>
  aline -ph 4 @Webchat Fermeture (inopinée?) d'un socket irc
  window -c @chat $+ %cook
  window -c @priv $+ %cook
  hfree hirc $+ %cook
  hfree priv $+ %cook
}

alias fermesi {
  var %chat
  %chat = $hget(hirc $+ $1,CHAT)
  if ($1 != $null && $sock(%chat).name == $null ) {  writeirc $1 QUIT : $+ %quitte }
}

alias closeweb {
  var %cook = $hget(in $+ $1,cookie)
  aline -ph 2 @Webchat Fermeture du socket web $1
  unset % $+ pos $+ $sockname
  .timer 1 5 /fermesi %cook
}

alias webopen {
  var %walea

  %walea = web $+ $ticks $+ $rand(1,1000) | sockaccept %walea
}

alias webread {
  var %fic, %para, %temp, %rien, %time

  set %fic $null
  set %para $null

  sockread %temp 

  if ( %writelog == oui ) {
    %time = $iif( $regex(%temp,/^(get|post|head|connect )/i) == 1 ,$time,$chr(9))
    if ( $asc(%time) != 9 ) { write Webchat/logs/log.txt - ( $+ $sock($1).ip $+ ) }
    write Webchat/logs/log.txt %time $iif(%temp == $null,(crlf),%temp)
  }

  if ( %temp != $null && $hget(in $+ $1,post) != 1 ) { 

    if ( $regex(%temp , /^get ([^? ]+)(\?\S+)?/i ) == 1 ) { set %fic $regml(1) | set %para $regml(2)
      set %rien $regsub(%para,/^\?/,,%para)
      if (%fic == / || %fic == /index.htm) { %fic = /index.html }
      sockmark $1 %fic | aline -ph 1 @Webchat $time : Get de %fic et ?= %para ( $sock($1).ip )
    hmake in $+ $1 }

    elseif ( $regex(%temp , /^post ([^? ]+)(\?\S+)?/i ) == 1 ) { set %fic $regml(1) | set %para $regml(2)
      set %rien $regsub(%para,/^\?/,,%para)
      sockmark $1 %fic 
      aline -ph 1 @Webchat  $time Post de %fic et ?= %para ( $sock($1).ip )
    hadd -m in $+ $1 post 0 }

    ;    elseif ( $regex(%temp , /^cookie: ID=(\S+)/i ) == 1 ) { 
    ; hadd -m in $+ $1 cookie $regml(1) 
    ;   }

    if ( /index isin %fic ) { hadd in $+ $1 cookie $ticks }
    if ( %para != $null ) { hadd in $+ $1 para %para }
  }

  elseif ( $hget(in $+ $1,post) == 0 ) { hadd in $+ $1 post 1 
    ; Fin de POST atteinte , la variable suit
  }

  else { 
    if ( $hget(in $+ $1,post) == 1 ) { 
      aline -ph 3 @Webchat Posté: %temp ( $sock($1).ip )
    hadd in $+ $1 post %temp | parse $1 %temp  }

    set %fic $sock($1).mark

    if (!$exists(Webchat $+ %fic)) { 

      aline -ph 6 @Webchat Page 404: %fic ( $sock($1).ip )

      sockwrite -n $1 HTTP/1.1 404 Not Found
      sockwrite -n $1 Keep-Alive: timeout=15, max=100
      sockwrite -n $1 Connection: Keep-Alive
      sockwrite -n $1 Content-Type: text/html
      sockwrite -n $1
      sockwrite -n $1 <HEAD><TITLE>Le fichier demandé n'a pas été trouvé.</TITLE></HEAD><BODY><H1>Erreur 404</H1>Le fichier demandé n'a pas été trouvé.<P></BODY>
      hfree in $+ $1 | sockclose $1
      halt
    }

    sockwrite -n $1 HTTP/1.0 200 $iif(.gif isin %fic || .wav isin %fic || .swf isin %fic || .jpg isin %fic,OK,Document follows)

    if ( .gif isin %fic ) { 
      sockwrite -n $1 Cache-control: public
      sockwrite -n $1 content-type: image/gif 
      ; echo 3 -s image gif 
    }
    elseif ( .wav isin %fic ) { 
      sockwrite -n $1 Content-Length: $file(webchat $+ %fic).size
      sockwrite -n $1 Cache-control: public
      sockwrite -n $1 content-type: audio/wav 
      ; echo 3 -s wave (une belle saleté) 
    }
    elseif ( .swf isin %fic ) { 
      sockwrite -n $1 Content-Length: $file(webchat $+ %fic).size
      sockwrite -n $1 Cache-control: public
      sockwrite -n $1 content-type: application/x-shockwave-flash 
    }
    elseif ( .jpg isin %fic ) { 
      sockwrite -n $1 Cache-control: public
      sockwrite -n $1 content-type: image/jpeg  
      ; echo 3 -s image jpg 
    }
    else { 
      sockwrite -n $1 Cache-Control: no-cache, no-store, private
      sockwrite -n $1 Pragma: no-cache
      sockwrite -n $1 content-type: text/html 
      ; echo 3 -s fichier html %fic  
    }

    if (index.htm isin %fic ) { 
      set %cook $rand(1000,10000) 
      sockwrite -n $1 Set-cookie: ID= $+ %cook 
      ; echo 7 -s genere cookie %cook sur %fic
    }

    sockwrite -n $1

    if ( .gif isin %fic || .jpg isin %fic || .wav isin %fic || .swf isin %fic ) { 
    litimage $1 %fic }
    else { traitehtml $1 %fic }
  }
}

alias litpage { 
  ;  echo 3 -s litpage $1 et $2
  var %i,%N,%nick,%userhost,%chan,%cook,%temp,%modes,%putain,%j

  if ($sock($1).name == $null ) { return }
  %cook = $hget(in $+ $1,cookie)

  set %nick $hget(hirc $+ %cook,NICK)
  set %chan $hget(hirc $+ %cook,CHAN)
  set %userhost $hget(hirc $+ %cook,USERHOST)
  set %modes $hget(hirc $+ %cook,MODES)

  hadd in $+ $1 nicklist %nicklist
  hadd in $+ $1 nick %nick
  hadd in $+ $1 canal %chan
  hadd in $+ $1 userhost %userhost
  hadd in $+ $1 modes %modes
  hadd in $+ $1 canaux $canaux(0)
  hadd in $+ $1 serveurs $serveurs(0)
  hadd in $+ $1 slaps $slaps(0)
  hadd in $+ $1 commandes $commandes(0)
  hadd in $+ $1 changenom $liremess(37)
  hadd in $+ $1 nickvalide $liremess(51)
  hadd in $+ $1 joindreserv $joindreserv

  %j = 1

  while ( %j <= %NVar ) {
    %putain = $gettok(%variables,%j,32)
    hadd in $+ $1 %putain $variables(%putain)
    inc %j
  }

  set %i 0 | set %N $lines(Webchat $+ $2)
  while ( %i < %N ) {
    inc %i
    set %temp $read -nl $+ %i Webchat $+ $2
    if (%temp != $null && !$subst-($1,%temp)) { sockwrite -n $1 $subst($1,%temp) }
    else { sockwrite -n $1 }
  }
  if ( .cgi !isin $2 ) { sockclose $1 | hfree in $+ $1  }
}

alias litimage { 
  set % $+ pos $+ $1 4096
  bread Webchat $+ $sock($sockname).mark 0 4096 &a
  sockwrite $1 &a
}

on 1:sockwrite:web*:{
  set %nomdedieu % $+ pos $+ $sockname
  if ( [ [ %nomdedieu ] ] == $null ) { return }

  if ( $sock($sockname).name == $null ) { halt }
  ;  :l
  if ($sock($sockname).sq < 16384) {
    set %putain Webchat $+ $sock($sockname).mark
    if ( $file(%putain).size > $calc( [ [ %nomdedieu ] ] - 4096)) {
      bread %putain [ [ %nomdedieu ] ] 4096 &a
      sockwrite $sockname &a
      inc % $+ pos $+ $sockname 4096
      ;     goto l
    }
    else { unset % $+ pos $+ $sockname | sockclose $sockname }
  }
}

alias subst {
  var %toto, %mimi, %exp, %rien, %zaza
  %toto = $2-
  %exp = /\$([a-zA-Z]+)/

  while ( $regex(SUB,%toto,%exp) == 1 ) {
    %mimi = $regml(SUB,1)
    %zaza = $iif($1 == 0,$getvariable(%mimi),$hget(in $+ $1,%mimi))

    %zaza = $replace(%zaza,$chr(36),$chr(29),\,$chr(30))
    %rien = $regsub(SUB,%toto,%exp,%zaza,%toto)
    %toto = $replace(%toto,$chr(29),$chr(36),$chr(30),\)
  }

  return %toto
}

alias subst- {
  var %toto, %mimi, %exp, %rien, %zaza, %N, %i
  %toto = $2-
  %exp = /\$(_[a-zA-Z]+)/

  if ( $regex(%toto,%exp) == 1 ) {
    %mimi = $regml(1)
    %N = $hget(%mimi,N)
    %i = 1

    while ( %i <= %N ) {
      sockwrite -n $1 $hget(%mimi,C $+ %i)
      inc %i
    }
    return $true
  }
  return $false
}

alias parse { 
  var %toto, %mimi, %momo, %exp, %exp1, %exp2, %rien, %i, %N

  ;  echo 6 -s Requete de $sock($1).ip 
  %toto = $2-
  %exp = /([^&]+)(&|$)/
  %exp1 = /([^=]+)=(.*)/
  %exp2 = /%([A-Z0-9]{2})/e

  %i = 1
  %N = $gettok(%toto,0,38)

  while ( %i <= %N ) {
    %mimi = $gettok(%toto,%i,38)

    %rien = $regex(%mimi,%exp1)

    %momo = $regml(1)
    %mimi = $regml(2)

    if ($right(%momo,1) == _ ) {

      %momo = $left(%momo,$calc($len(%momo)-1))

    } 
    else   {
      %rien = $regsub(%mimi,/\+/ge,$chr(32),%mimi)

      %mimi = $replace(%mimi,% $+ 24,$)
      %mimi = $replace(%mimi,% $+ 5C,\)

      ; Obligé de faire ça a cause d'un putain de bug de mirc (le $ et le \ ne triggent pas dans un regsub)

      while ( $regex(%mimi,%exp2) == 1 ) {
        %rien = $regsub(%mimi,%exp2,$chr($hex($regml(1))),%mimi)
      }
    }
    ; echo 7 -s %momo egal %mimi

    if ( %mimi ) { hadd in $+ $1 %momo %mimi }
    inc %i
  }

}

alias hex {
  var %a, %b

  %a = $left($1,1) | %b = $right($1,1)
  if ($asc(%a) > 64 ) { %a = $calc($asc(%a) - 55) } 
  if ($asc(%b) > 64 ) { %b = $calc($asc(%b) - 55) } 

  return $calc(%a * 16 + %b)
}

alias ircopen {
  var %nick, %user

  if ($sockerr > 0) { sockclose web* | halt }

  %cook = $right($1,$calc($len($1)-3))
  %nick = $hget(hirc $+ %cook,NICK)
  %user = webchat

  sockwrite -n $1 NICK %nick
  sockwrite -n $1 USER %user %user %user :WebChat $variables(ver)

  aline -ph 4 @Webchat Ouverture d'un socket irc! ( $1 )
}

alias ircread {
  var %cook, %chan, %me, %temp, %chat, %ban

  %cook = $right($1,$calc($len($1)-3)) 
  %chan = $hget(hirc $+ %cook,CHAN)
  %me = $hget(hirc $+ %cook,NICK)
  %ban = $hget(hirc $+ %cook,BAN)

  if ( $sockerr > 0 ) { echo 4 -s ERREUR DE MERDE | halt }
  sockread %temp 

  if ( %temp != $null ) { 
    %g = $asc($gettok(%temp,3,32))
    if ( $gettok(%temp,2,32) == privmsg && %g != 35 && %g != 38 ) {
      aline -ph 1 @priv $+ %cook %temp 
    }
    else { aline -ph 1 @chat $+ %cook %temp  }
  }

  if ( $left(%temp,4) == PING ) { sockwrite -n $1 PONG $gettok(%temp,2,32) | return }

  if ( $regex($gettok(%temp,2,32),/(376|422)/) == 1 && $hget(hirc,%cook) == $null ) {
    ; ca passe...

    sockwrite -n $1 USERHOST %me
  }

  elseif ( $regex(%temp,/^\S+ 302 \S+ :([^=]+)=\+(.+)$/) == 1 ) {
    if ( $hget(hirc,%cook) == $null ) {
      hadd -m hirc %cook oui
      hadd hirc $+ %cook USERHOST $regml(2)
      %chat = $hget(hirc $+ %cook,SIGNON)

    litpage %chat $sock(%chat).mark }

    else {
      ; il s'agit d'un ban
      %ban = $iif(%ban == $null,1,%ban)
      sockwrite -n $1 MODE %chan +b $mask($regml(1) $+ ! $+ $regml(2),%ban)
      .timer 1 %bantime  /sockwrite -n $1 MODE %chan -b $mask($regml(1) $+ ! $+ $regml(2),%ban)
    }

  }

  elseif ( $regex(%temp,/^:(\S+) join :?(.+)$/i) == 1 ) { 
    if ( $gettok($regml(1),1,33) == %me ) { 
      hadd hirc $+ %cook CHAN $regml(2) 
      hadd hirc $+ %cook JOIN $regml(2)
      writeirc %cook MODE $regml(2)
      println $1 6 <script> parent.topic("\
      printmirc $1 1
      println $1 6 "); </script>

    }
    print $1 %temp
  }

  elseif ( $regex(%temp,/^:(\S+) nick :?(.+)$/i) == 1 ) { 
    if ( $gettok($regml(1),1,33) == %me ) { 
      hadd hirc $+ %cook NICK $regml(2)
    }
    print $1 %temp
  }

  elseif ( $regex(%temp,/^:(\S+) mode (\S+) \S+$/i) == 1 ) {
    writeirc %cook MODE $regml(2)
    print $1 %temp
  }

  elseif ( $regex(%temp,/^:\S+ 432/) == 1 && $hget(hirc,%cook) == $null) {
    sockclose -n irc $+ %cook
    %chat = $hget(hirc $+ %cook,SIGNON)
    sockwrite -n %chat <head><title>Error!!</title></head><body bgcolor= $+ %fond $+ ><center><h2><br> $+ $liremess(38) $+ <br><br><a href=/> $+ $liremess(39) $+ </a></h2></body>
    ; nickname interdit!
    sockclose %chat
  }

  elseif ( $regex(%temp,/^:\S+ 433 (\S+)/) == 1 && $hget(hirc,%cook) == $null) {
    sockclose -n irc $+ %cook
    %chat = $hget(hirc $+ %cook,SIGNON)
    sockwrite -n %chat <head><title>Error!!</title></head><body bgcolor= $+ %fond $+ ><center><h2><br> $regml(1) $+ : $liremess(40) $+ <br><br><a href=/> $+ $liremess(41) $+ </a></h2></body>
    sockclose %chat
    ; nickname deja pris!
  }

  elseif ( $regex(%temp,/^error (.+)/i) == 1) {
    sockclose -n irc $+ %cook
    %chat = $hget(hirc $+ %cook,SIGNON)

    println $1 0 <script>alert(" $+ $liremess(42) $+ \n $+ $regml(1) $+ "); window.top.location.href="/"; </script>

    sockwrite -n %chat <head><title>Error!!</title></head><body bgcolor= $+ %fond $+ ><center><h2><br> $+ $liremess(43) $+ <br><br> <font color=red> $regml(1) </font><br><br><a href=/> $+ $liremess(44) $+ </a></h2></body>
    sockclose %chat
  }


  else { print $1 %temp }
}

alias traitement {
  var %cook = $hget(in $+ $1,cookie)
  var %texte = $hget(in $+ $1,C)
  var %chan = $hget(hirc $+ %cook,CHAN)
  var %nick = $hget(hirc $+ %cook,NICK)

  if ( $regex(%texte,/^\/names (\S+)/i) == 1 ) { 
    if ( $regml(1) == * ) { writeirc %cook NAMES %chan  }
    else { writeirc %cook NAMES $regml(1)  }
    return $true
  }

  elseif ( $regex(%texte,/^\/(m|msg) (\S+) (.+)$/i) == 1 ) {
    if ( %restrict == oui && !$isonchat($regml(2),irc $+ %cook) && $regml(2) != %chan) {
      println irc $+ %cook 0 <font color=blue> %texte $+ : $liremess(54) </font>
    } 
    else {
      println irc $+ %cook 1 <font color=black face="courier new" size=2> -> * $+ $regml(2) $+ * $smiley($regml(3)) </font>
      writeirc %cook PRIVMSG $regml(2) : $+ $regml(3)
    jedis irc $+ %cook $regml(2) $regml(3) }
    return $true
  }

  elseif ( $regex(%texte,/^\/(n|notice) (\S+) (.+)$/i) == 1 ) {
    if ( %restrict == oui && !$isonchat($regml(2),irc $+ %cook) && $regml(2) != %chan ) {
      println irc $+ %cook 0 <font color=blue> %texte $+ : $liremess(54) </font>
    } 
    else {
      println irc $+ %cook 1 <font color=black face="courier new" size=2> -> - $+ $regml(2) $+ - $smiley($regml(3)) </font>
    writeirc %cook NOTICE $regml(2) : $+ $regml(3) }
    return $true
  }

  elseif ( $regex(%texte,/^\/me (.+)$/i) == 1 ) {
    println irc $+ %cook 1 <font color= $+ %moi face="courier new" size=2> * %nick $smiley($regml(1)) </font>
    writeirc %cook PRIVMSG %chan :ACTION $regml(1) $+ 
    return $true
  }

  elseif ( $regex(%texte,/^\/(w|whois) (.+)$/i) == 1 ) {
    writeirc %cook WHOIS $regml(2)
    return $true
  }

  elseif ( $regex(%texte,/^\/join ([^,\$]+)$/i) == 1 ) {
    if ( ( %changechan != oui || %restrict == oui ) && $regml(1) != %chan && $regml(1) != * ) {
      println irc $+ %cook 0 <font color=blue> %texte $+ : $liremess(28) </font>
      if ($3 == 1) litpage $1 $2 
    }
    else {
      writeirc %cook PART %chan
      if ( $regml(1) == * ) { writeirc %cook JOIN %chan }
      else { writeirc %cook JOIN $regml(1) }
    }
    return $true
  }

  elseif ( $regex(%texte,/^\/j ([^,\$]+)$/i) == 1 ) {
    if ( ( %changechan != oui || %restrict == oui ) && $chr(35) $+ $regml(1) != %chan && $regml(1) != * ) {
      println irc $+ %cook 0 <font color=blue> %texte $+ : $liremess(28) </font>
      if ($3 == 1) litpage $1 $2 
    }
    else {
      writeirc %cook PART %chan
      if ( $regml(1) == * ) { writeirc %cook JOIN %chan }
      else { writeirc %cook JOIN $chr(35) $+ $regml(1) }
    }
    return $true
  }

  elseif ( $regex(%texte,/^\/invite (\S+) (\S+)$/i) == 1 ) {
    if ( %restrict == oui ) { println irc $+ %cook 0 <font color=blue> %texte $+ : $liremess(54) </font>
    }
    else {
      if ( $regml(2) == * ) { writeirc %cook INVITE $regml(1) %chan }
      else { writeirc %cook INVITE $regml(1) $regml(2) }
    }
    return $true
  }

  elseif ( $regex(%texte,/^\/nick ([\w-]+)$/i) == 1 ) {
    if ( %changenick != oui ) {
      println irc $+ %cook 0 <font color=blue> %texte $+ : $liremess(29) </font>
      if ($3 == 1) litpage $1 $2
    }
    else {
      writeirc %cook NICK : $+ $regml(1)
    }
    return $true
  }

  elseif ( $regex(%texte,/^\/(q|query) (\S+)$/i) == 1 ) {
    if ( %restrict == oui && !$isonchat($regml(2),irc $+ %cook) && $regml(2) != %chan) {
      println irc $+ %cook 0 <font color=blue> %texte $+ : $liremess(54) </font>
    } 
    else {
      %nick = $regml(2)
      %id = $assigne(irc $+ %cook,%nick)
      %nick = $replace(%nick,\,\\,",\")
      println irc $+ %cook 6 <script> parent.parle(" $+ %nick $+ ", $+ %id $+ ); </script>
    }
    return $true
  }

  elseif ( $regex(%texte,/^\/list ?(.*)$/i) == 1 ) {
    if ($gettok($regml(1),1,32) == -min ) {
      writeirc %cook LIST > $+ $gettok($regml(1),2,32)
    }
    elseif ($gettok($regml(1),1,32) == -max ) {
      writeirc %cook LIST < $+ $gettok($regml(1),2,32)
    }
    else { writeirc %cook LIST $regml(1) } 
    return $true
  }

  elseif ( $regex(%texte,/^\/topic (\S+) ?(.*)$/i) == 1 ) {
    writeirc %cook TOPIC $regml(1) : $+ $regml(2)
    return $true
  }

  elseif ( $regex(%texte,/^\/ping (\S+)?$/i) == 1 ) {
    println irc $+ %cook 1 <font color=red> -> $chr(91) $+ $regml(1) $+ $chr(93) PING </font>
    writeirc %cook PRIVMSG $regml(1) : $+ PING $ctime $+ 
    return $true
  }

  elseif ( $regex(%texte,/^\/ctcp (\S+) (\S+)( .+)?$/i) == 1 ) {
    println irc $+ %cook 1 <font color=red> -> $chr(91) $+ $regml(1) $+ $chr(93) $upper($regml(2)) $regml(3) </font>
    if ( $regml(3) == $null ) { writeirc %cook PRIVMSG $regml(1) : $+ $upper($regml(2)) $+  }
    else { writeirc %cook PRIVMSG $regml(1) : $+ $upper($regml(2)) $regml(3) $+  }
    return $true
  }

  elseif ( $regex(%texte,/^\/ban (\S+) ?(\d+)?$/i) == 1 ) {
    hadd hirc $+ %cook BAN $regml(2)
    writeirc %cook USERHOST $regml(1)
    return $true
  }

  elseif ( $regex(%texte,/^\/away ?(.*)$/i) == 1 ) {
    if ($regml(1) != $null ) { 
    writeirc %cook AWAY : $+ $regml(1) }
    else { writeirc %cook AWAY }
    return $true
  }

  elseif ( $regex(%texte,/^\/raw (.+)$/i) == 1 && %raws == oui ) {
    writeirc %cook $regml(1)
    println irc $+ %cook 0 <font color=black> %texte -> Serveur: $regml(1) </font>
    return $true
  }
}

alias traitehtml { 
  var %cook, %nick, %chan, %temp, %N, %i, %texte, %chat, %liste, %modes, %newmode, %net

  parse $1 $hget(in $+ $1,para)
  %cook = $hget(in $+ $1,cookie) 

  if ( %cook == $null ) {
    %cook = $hget(session,$longip($sock($1).ip))
    hadd -m in $+ $1 cookie %cook
    ;   echo 4 -a get de $hget(session,$longip($sock($1).ip)) ( $longip($sock($1).ip) )
  }
  else {
    hadd -m session $longip($sock($1).ip) %cook
    ;   echo 4 -a écriture de cookie %cook ( $longip($sock($1).ip) )
  }

  if ( /signon isin $2 ) { 

    %cook = $hget(in $+ $1,cookie)
    if ( %cook == $null ) { sockwrite -n $1 <body bgcolor=#c0c0c0><center><h2><br> $liremess(52) </h2></center></body> | sockclose $1 | halt }

    window -heSkl12 @chat $+ %cook
    window -hek @priv $+ %cook
    set %window @chat $+ %cook

    if ( $hget(hirc,%cook) != $null ) {
      ; la session existe déjà
      hadd hirc $+ %cook SIGNON $1
      litpage $1 $2
    }
    else { 
      %nick = $hget(in $+ $1,N)
      %chan = $hget(in $+ $1,C)
      %net = $hget(in $+ $1,NET)

      hmake hirc $+ %cook
      hmake priv $+ %cook
      hmake id $+ %cook

      hadd hirc $+ %cook NICK %nick
      hadd hirc $+ %cook CHAN %chan
      hadd hirc $+ %cook SIGNON $1
      hadd hirc $+ %cook SERV %net

      hadd in $+ $1 serveur $serveurs(%net,1)

      sockclose identd | if ($portfree(113)) socklisten identd 113
      sockopen irc $+ %cook $serveurs(%net,2) $serveurs(%net,3)
    }
  }

  elseif ( /chat isin $2 ) { 
    %cook = $hget(in $+ $1,K)
    %chan = $hget(hirc $+ %cook,CHAN)

    hadd hirc $+ %cook CHAT $1
    litpage $1 $2

    set %i 0 | set %N $lines(Webchat/logs/chat $+ %cook $+ .htm)
    if ( %N == $null ) { %N = -1 }
    while ( %i < %N ) {
      inc %i
      set %temp $read -nl $+ %i Webchat/logs/chat $+ %cook $+ .htm
      sockwrite -nt $1 %temp
    }
  }

  elseif ( /menu isin $2 ) { 
    ; Le menu est le dernier fichier à s'afficher

    %cook = $hget(in $+ $1,cookie)
    %chan = $hget(hirc $+ %cook,CHAN)

    if ( $hget(hirc $+ %cook,MENU) == $null ) {
      writeirc %cook JOIN %chan
      ; Ne joindre le chan qu'au 1er appel
    }
    hadd hirc $+ %cook MENU $1

    litpage $1 $2
  }

  elseif ( /querycontrol isin $2 ) { 
    %cook = $hget(in $+ $1,cookie)
    %texte = $hget(in $+ $1,C)
    %K = $hget(in $+ $1,K)
    %nick = $hget(hirc $+ %cook,NICK)
    %qui = $hget(priv $+ %cook,%K)

    if ( %texte == $null ) {
      litpage $1 $2 
      %N = $lines(Webchat/logs/priv $+ %K $+ .htm)
      %i = 1
      sockwrite -n $1 <script> doc= parent.querychatwin.document;
      while ( %i <= %N ) {
        %mes = $read -nl $+ %i Webchat/logs/priv $+ %K $+ .htm
        %mes = $replace(%mes,\,\\,",\",',\')
        sockwrite -n $1 doc.writeln(" $+ %mes $+ ");
        inc %i
      }
      sockwrite -n $1 doc.writeln("<a name=bas></a>");
      sockwrite -n $1 doc.writeln("<scr"+"ipt> window.location='#bas'; </scr"+"ipt>"); </script>
      sockclose $1 | hfree in $+ $1
    } 

    else {
      ; texte pas nul

      if ( $asc(%texte) != 47 ) {  

        ; cas d'un message simple

        writeirc %cook PRIVMSG %qui : $+ %texte
        jedis irc $+ %cook %qui %texte
      }
      else {
        if ( $regex(%texte,/^\/me (.+)$/i) == 1 ) {
          writeirc %cook PRIVMSG %qui :ACTION $regml(1) $+ 
          jeluidis irc $+ %cook %qui $regml(1)
        }
        elseif ( $regex(%texte,/^\/ping (\S+)?$/i) == 1 ) {
          println irc $+ %cook 1 <font color=red> -> $chr(91) $+ $iif($regml(1) == *,%qui,$regml(1)) $+ $chr(93) PING </font>
          writeirc %cook PRIVMSG $iif($regml(1) == *,%qui,$regml(1)) : $+ PING $ctime $+ 
        }
        elseif ( $regex(%texte,/^\/(w|whois) (\S+)?$/i) == 1 ) {
          writeirc %cook WHOIS $iif($regml(2) == *,%qui,$regml(2))
        }
        elseif (!$traitement($1,$2,0)) { 
          sendpriv irc $+ %cook %qui 12 $+ %texte $+ : $liremess(36)
        }
        ; C'est une erreur!
      }
      litpage $1 $2 
      sockclose $1 | hfree in $+ $1
    }
  }


  elseif ( /control isin $2 ) { 
    %cook = $hget(in $+ $1,cookie)
    %texte = $hget(in $+ $1,C)
    %chan = $hget(hirc $+ %cook,CHAN)
    %nick = $hget(hirc $+ %cook,NICK)

    if ( %texte != $null && $asc(%texte) != 47 ) {  

      println irc $+ %cook 1 <font color= $+ %moi face="courier new" size=2> &lt; $+ $prefix(%nick,irc $+ %cook) $+ &gt; $smiley(%texte) </font>
      writeirc %cook PRIVMSG %chan : $+ %texte
    }
    else  { 
      if ($traitement($1,$2,1)) { }

      elseif ( $regex(%texte,/^\/kick (\S+) (\S+) ?(.*)$/i) == 1 ) {
        if ( $regml(1) == * ) { writeirc %cook KICK %chan $regml(2) : $+ $regml(3) }
        else { writeirc %cook KICK $regml(1) $regml(2) : $+ $regml(3) }
      }

      elseif ( $regex(%texte,/^\/k (\S+) ?(.*)$/i) == 1 ) {
        writeirc %cook KICK %chan $regml(1) : $+ $regml(2)
      }

      elseif ( $regex(%texte,/^\/mode (\S+) (\S+) ?(.*)$/i) == 1 ) {
        if ( $regml(1) == * ) { writeirc %cook MODE %chan $regml(2) $regml(3) }
        else { writeirc %cook MODE $regml(1) $regml(2) $regml(3) }
        %newmode = $regml(2)
      }

      elseif ( $regex(%texte,/^\/op (.+)$/i) == 1 ) {
        writeirc %cook MODE %chan +ooo $regml(1) 
      }

      elseif ( $regex(%texte,/^\/dop (.+)$/i) == 1 ) {
        writeirc %cook MODE %chan -ooo $regml(1) 
      }

      elseif ( $regex(%texte,/^\/quit ?(.*)$/i) == 1 ) {
        println irc $+ %cook 0 <font color=FF0000> $+ $liremess(45) $+ </font>
        println irc $+ %cook 0 <P><CENTER><FONT SIZE=2><A HREF=http://mircscriptsfrfm.com/webchat TARGET=webchat><IMG SRC=../image/mscriptayo.gif BORDER=0 alt=" $+ $liremess(46) $+ ">
        println irc $+ %cook 0 $liremess(46) $+ </A></FONT></CENTER><BR><BR>
        println irc $+ %cook 0 <FONT COLOR=0000FF>Signoff: %nick (<A TARGET=USERURL HREF="http://www.mircscriptsfrfm.com">http://www.mircscriptsfrfm.com</A>)</FONT>
        sockclose $hget(hirc $+ %cook,CHAT)
        sockwrite -n $1 <body bgcolor= $+ %fond $+ ><script> parent.fermetout(); </script><center><a href=/ target=_top><h2> $+ $liremess(47 ) $+ </a></h2></center></body> | sockclose $1
        writeirc %cook QUIT : $+ $iif($regml(1) == $null,%quitte,$regml(1))
        halt
      }

      elseif ( %texte != $null ) {
        println irc $+ %cook 0 <font color=blue> %texte $+ : $liremess(30) </font>
        litpage $1 $2
        ; Commande interdite
      }
    }

    if ( $sock(irc $+ %cook).name == $null ) {   sockwrite -n $1 <body><script> parent.fermetout(); alert(" $+ $liremess(55) $+ "); window.top.location.href="/"; </script></body> | sockclose $1 | halt }

    if ( $hget(hirc $+ %cook,MENU) != $null && $regex(%texte,/^\/(join #|j |nick [\w-]+|mode #\S+ \S+$)/i) == 0 ) { litpage $1 $2 }
    else { hadd hirc $+ %cook CONTROL $1 | .timer 1 5 litpage $1 $2 }

  }
  else  { litpage $1 $2 }
}

alias println {
  ; socket_irc, indicateur, texte
  ; indic = 0 si pas d'heure + <br> au bout (pas de </font> )
  ; indic = 1 si heure + <br> + </font>
  ; indic = 2 si pas d'heure sans <br> (pas de </font>)
  ; indic = 3 si heure sans <br> et sans </font> à la fin
  ; si ligne commencant par <script> alors pas de <br>
  ; rajouter 4 si on veut pas ecrire dans le log

  var %cook, %chat, %chan, %nick, %br, %time, %time2, %d2

  %d2 = $2
  if ( $2 > 3 ) { %d2 = $calc($2 - 4) }
  %cook = $right($1,$calc($len($1)-3)) 
  %chat = $hget(hirc $+ %cook,CHAT)
  if ( $sock(%chat).name == $null ) return
  %chan = $hget(hirc $+ %cook,CHAN)
  %nick = $hget(hirc $+ %cook,NICK)
  %br = $iif($left($3,4) != <SCR && $2 < 2, <br> )

  %time = <font color=darkgray size=2 face="courier new">[ $+ $left($time,5) $+ ]
  %time2 = </font>

  if ( %d2 == 0 || %d2 == 2 ) { %time = $null | %time2 = $null }
  if ( %d2 == 3 ) { %time2 = $null }

  ; echo 1 -a $len(%time $3- $+ %br %time2)

  sockwrite -nt %chat %time $3- $+ %br %time2
  if ( $2 < 4 ) { write Webchat/logs/chat $+ %cook $+ .htm %time $3- $+ %br %time2 }

  if ( %br != $null ) {
    sockwrite -n %chat <SCRIPT>do_scrolldown();</SCRIPT>
    ;   write Webchat/logs/chat $+ %cook $+ .htm <SCRIPT>do_scrolldown();</SCRIPT>
  }
}

alias validecontrol {
  var %control

  %control = $hget(hirc $+ $1,CONTROL)
  if ( %control != $null ) {
    litpage %control $sock(%control).mark
    hdel hirc $+ $1 CONTROL
  }
}

alias print {
  var %cook, %chat, %chan, %chan2, %nick, %temp, %userhost, %me, %mess, %ism, %liste, %knick, %newnick, %modes, %ctcp, %signe

  %cook = $right($1,$calc($len($1)-3)) 
  %chat = $hget(hirc $+ %cook,CHAT)

  if ( $sock(%chat).name == $null ) return
  %chan = $hget(hirc $+ %cook,CHAN)
  %me = $hget(hirc $+ %cook,NICK)
  %temp = $2-

  if ( $regex(%temp,/^:\S+ 353 \S+ \S (\S+) :(.+)$/) == 1 ) {
    %chan2 = $regml(1)
    %liste = $regml(2)
    %ism = $hget(hirc $+ %cook,LISTE)

    println $1 0 <font color=red> $+ $liremess(1,%chan2,%liste) </font>
    if ( %chan == %chan2 ) {
      if ( %ism == $null ) { hadd hirc $+ %cook LISTE oui | %ism = 1 }
      else { %ism = 0 }

      addmembers %ism $1 %chan %liste
    }
    ; Chatteurs sur
  }

  elseif ( $regex(%temp,/^:\S+ 366 \S+ (\S+)/) == 1 && $regml(1) == %chan) {
    hdel hirc $+ %cook LISTE
    sendmembers 1 $1 $regml(1)
  }

  elseif ( $regex(%temp,/^:\S+ 332 \S+ \S+ :(.+)$/) == 1 ) {
    println $1 2 <font color= $+ %modecol $+ > $+ $liremess(2) 
    %liste = $regml(1)
    printmirc $1 0 $regml(1)
    println $1 0 </font>
    println $1 6 <script> parent.topic("\
    printmirc $1 1 %liste
    println $1 6 "); </script>
    ; Thème canal
  }

  elseif ( $regex(%temp,/^:\S+ 333 \S+ \S+ (\S+) (\S+)$/) == 1 ) {
    println $1 0 <font color= $+ %modecol $+ > $+ $liremess(3,$regml(1),$date($regml(2)),$time($regml(2))) </font>
    ; Thème mis par
  }

  elseif ( $regex(%temp,/^:\S+ 311 \S+ (\S+) (\S+) (\S+) \* ?:?(.+)?$/) == 1 ) {
    %mess = $smiley($regml(4))
    %nick = $regml(1)
    println $1 0 -
    println $1 0 <font color=black> $+ $liremess(4,$regml(1),$regml(2),$regml(3),%mess) </font>
    sendpriv $1 $regml(1) $liremess(4,$regml(1),$regml(2),$regml(3),$regml(4))
    ; machin is truc@bidule
    ; 3 raws de /whois
  }

  elseif ( $regex(%temp,/^:\S+ 319 \S+ (\S+) :(.+)?$/) == 1 ) {
    println $1 0 <font color=black> $+ $liremess(5,$regml(1),$smiley($regml(2))) </font>
    sendpriv $1 $regml(1) $liremess(5,$regml(1),$regml(2))
    ; machin sur les canaux
  }

  elseif ( $regex(%temp,/^:\S+ 312 \S+ (\S+) (\S+) ?:?(.+)?$/) == 1 ) {
    println $1 0 <font color=black> $+ $liremess(6,$regml(1),$regml(2),$regml(3)) </font>
    sendpriv $1 $regml(1) $liremess(6,$regml(1),$regml(2),$regml(3))
    ; machin sur le serveur
  }

  elseif ( $regex(%temp,/^:\S+ 301 \S+ (\S+) :(.+)?$/) == 1 ) {
    %nick = $regml(1)
    %mess = $regml(2)
    println $1 2 <font color=black> $+ $liremess(31,%nick) </font>
    printmirc $1 0 %mess
    println $1 0 </font>
    sendpriv $1 %nick $liremess(31,%nick) %mess

    ; machin est away
  }

  elseif ( $regex(%temp,/^:\S+ 306/) == 1 ) {
    println $1 0 <font color=black> $+ $liremess(32) </font>

    ; vous êtes away
  }

  elseif ( $regex(%temp,/^:\S+ 305/) == 1 ) {
    println $1 0 <font color=black> $+ $liremess(33) </font>

    ; vous n'êtes plus away
  }

  elseif ( $regex(%temp,/^:\S+ (318|368|323|321)/) == 1 ) {
    println $1 0 -

    ; délimiteur de whois, de ban ou de list
  }

  elseif ( $regex(%temp,/^:\S+ 421 \S+ (\S+)/) == 1 ) {
    println $1 0 <font color=black> $+ $liremess(34,$regml(1)) </font>

    ; commande inconnue
  }

  elseif ( $regex(%temp,/^:\S+ 322 \S+ (\S+) (\d+) :?(.+)?/) == 1 ) {
    println $1 2 <font color=black><b> $+ $liremess(7,$smiley($regml(1)),$regml(2)) </b> : 
    printmirc $1 0 $regml(3) 
    println $1 0 </font>
    ; canal listé avec son topic
  }

  elseif ( $regex(%temp,/^:\S+ 472 \S+ \S+ (\S+)/) == 1 ) {
    println $1 0 <font color=black> $+ $liremess(8,$regml(1)) </font>
    validecontrol %cook
    ; mode inconnu
  }

  elseif ( $regex(%temp,/^:\S+ 482 \S+ (\S+)/) == 1 ) {
    println $1 0 <font color=black> $+ $liremess(9,$regml(1)) </font>
    validecontrol %cook
    ; pas op!
  }

  elseif ( $regex(%temp,/^:\S+ 401 \S+ (\S+)/) == 1 ) {
    println $1 0 <font color=black> $+ $liremess(10,$regml(1)) </font>
    sendpriv $1 $regml(1) $liremess(10,$regml(1))
    validecontrol %cook
    ; no such nick
  }

  elseif ( $regex(%temp,/^:\S+ 404 \S+ (\S+)/) == 1 ) {
    println $1 0 <font color=black> $+ $liremess(11,$regml(1)) </font>
    ; cannot send
  }

  elseif ( $regex(%temp,/^:\S+ (471|473|474|475) \S+ (\S+) :?(.+)$/) == 1 ) {
    println $1 0 <font color=black> $+ $liremess(12,$regml(2),$regml(3)) </font>
    validecontrol %cook

    ; Les 4 raws anti-join (+b, +i,+l, +k)
  }

  elseif ( $regex(%temp,/^:\S+ 324 \S+ (\S+) (\S+)/) == 1 ) { 
    hadd hirc $+ %cook MODES $regml(2) 
    validecontrol %cook

    ; Retour de /mode #, qui est effectué lorsqu'on joint un canal ou lors d'un changement de mode
  }

  elseif ( $regex(%temp,/^:\S+ 433 (\S+)/) == 1 ) {
    println $1 0 <font color=black> $+ $liremess(13,$regml(1)) </font>
    validecontrol %cook
    ; nick dejà pris
  }

  elseif ( $regex(%temp,/^:\S+ 341 \S+ (\S+) (\S+)/) == 1 ) { 
    println $1 0 <font color=black> $+ $liremess(14,$regml(1),$regml(2)) </font>
    ; nick vient d'etre invité
  }

  elseif ( $regex(%temp,/^:\S+ 443 \S+ (\S+) (\S+)/) == 1 ) { 
    println $1 0 <font color=black> $+ $liremess(15,$regml(1),$regml(2)) </font>
    ; nick est deja sur le canal

  }

  elseif ( $regex(%temp,/^:\S+ 367 \S+ \S+ (\S+) (\S+) (\S+)/) == 1 ) { 
    println $1 0 <font color=black> $+ $liremess(35,$regml(1),$regml(2),$date($regml(3)),$time($regml(3))) </font>
    validecontrol %cook
    ; liste bannis

    ; Fin du traitement des raws
  }

  elseif ( $regex(%temp,/^:\S+ (\d+) \S+ ?(.*)/) == 1 && %raws == oui ) {
    println $1 0 <font color=red> Raw $regml(1) $+ : $regml(2) </font>
  }

  elseif ( $regex(%temp,/^:(\S+) join :?(.+)$/i) == 1 ) {
    %nick = $gettok($regml(1),1,33)
    %userhost = $gettok($regml(1),2,33)
    %chan = $regml(2)

    if ( %nick != %me ) {
      println $1 1 <font color= $+ %join $+ > $+ $liremess(16,%nick,%userhost,%chan) </font>
    addmember 0 $1 %chan %nick | addni %nick $1 }
    else { println $1 1 <font color= $+ %join $+ > $+ $liremess(17,%chan) </font> }
    ; join de canal
  }

  elseif ( $regex(%temp,/^:(\S+) part :?(\S+)( .+)?$/i) == 1 ) {
    %nick = $gettok($regml(1),1,33)
    %userhost = $gettok($regml(1),2,33)
    %chan = $regml(2)
    %mess = $regml(3)
    %ism = $regsub(%mess,/^ :/,,%mess)

    if ( %nick == %me ) {
      println $1 1 <font color= $+ %join $+ > $+ $liremess(18,%chan,$iif(%ism == 1,( $+ %mess $+ ) )) </font>
      println $1 4 <SCRIPT>remove_all_members(" $+ %chan $+ ")</SCRIPT>
    }
    else {
      println $1 3 <font color= $+ %join $+ > $+ $liremess(19,%nick,%userhost,%chan )
      if (%ism == 1) { printmirc $1 0 ( $+ %mess $+ ) 
      }
      println $1 0 </font></font>
      delmember $1 %chan %nick | remni %nick $1
    }
    ; part de canal
  }

  elseif ( $regex(%temp,/^:(\S+) quit( .+)?$/i) == 1 ) {
    %nick = $gettok($regml(1),1,33)
    %userhost = $gettok($regml(1),2,33)
    %mess = $regml(2)
    %ism = $regsub(%mess,/^ :/,,%mess)

    println $1 3 <font color= $+ %quit $+ > $+ $liremess(20,%nick,%userhost)
    if (%ism == 1) { printmirc $1 0 ( $+ %mess $+ )      
    }
    println $1 0 </font></font>
    delmember $1 %chan %nick | remni %nick $1
    ; nick a quitté
  }

  elseif ( $regex(%temp,/^:(\S+) kick (\S+) (\S+)( .+)?$/i) == 1 ) {
    %nick = $gettok($regml(1),1,33)
    %userhost = $gettok($regml(1),2,33)
    %chan = $regml(2)
    %knick = $regml(3)
    %mess = $regml(4)
    %ism = $regsub(%mess,/^ :/,,%mess)

    if ( %knick == %me ) {
      println $1 3 <b><font color= $+ %kick $+ > $+ $liremess(21,%nick) </b>
      if (%ism == 1) { printmirc $1 0 ( $+ %mess $+ ) }
      println $1 0 </font></font>

      println $1 4 <SCRIPT>remove_all_members(" $+ %chan $+ ")</SCRIPT>
    } 
    else {
      println $1 3 <font color= $+ %kick $+ > $+ $liremess(22,%knick,%nick)
      if (%ism == 1) { printmirc $1 0 ( $+ %mess $+ ) }
      println $1 0 </font></font>

      delmember $1 %chan %knick | remni %knick $1
    }
    ; got kicked
  }

  elseif ( $regex(%temp,/^:(\S+) privmsg (\S+) :(.*)$/i) == 1 ) {
    %nick = $gettok($regml(1),1,33)
    %userhost = $gettok($regml(1),2,33)
    %chan = $regml(2)
    %mess = $regml(3)

    if ( $asc(%chan) == 35 || $asc(%chan) == 38 ) {

      ; Cas public

      if ($regsub(%mess,/^action/i,,%mess) == 1 ) {
        ; Cas du /me

        %mess = $left(%mess,$calc($len(%mess)-1))
        println $1 3 <font color= $+ %action face="courier new" size=2> * $prefix(%nick,$1)
        printmirc $1 0 %mess 
        println $1 0 </font></font>
      }

      elseif ($regsub(%mess,/^([^ ]+)/,,%mess) == 1 ) {
        ; Cas du /ctcp canal

        %mess = $left(%mess,$calc($len(%mess)-1))
        %ctcp = $regml(1)
        if ( %ctcp == PING ) { gereping $1 %nick %mess | %mess = $null }
        elseif ( %ctcp == version ) { gereversion $1 %nick %mess }

        println $1 3 <font color=red face="courier new" size=2> $chr(91) $+ $prefix(%nick,$1) $+ : $+ %chan $upper(%ctcp) $+ $chr(93)
        printmirc $1 0 %mess 
        println $1 0 </font></font>
      }

      else {
        println $1 3 <font color= $+ %reg face="courier new" size=2> &lt; $+ $prefix(%nick,$1) $+ &gt; 
        printmirc $1 0 %mess 
      println $1 0 </font></font>      }
    }


    else {

      ; Cas privé

      if ($regsub(%mess,/^action/i,,%mess) == 1 ) {
        ; Cas du /me

        %mess = $left(%mess,$calc($len(%mess)-1))
        if ( %echo == oui ) {
          println $1 3 <font color= $+ %action face="courier new" size=2> * $+ %nick $+ *
          printmirc $1 0 %mess 
          println $1 0 </font></font>
        }
        ilmedit $1 %nick %mess
      }

      elseif ($regsub(%mess,/^([^ ]+)/,,%mess) == 1 ) {
        ; Cas du /ctcp nick

        %mess = $left(%mess,$calc($len(%mess)-1))
        %ctcp = $regml(1)
        if ( %ctcp == PING ) { gereping $1 %nick %mess | %mess = $null }
        elseif ( %ctcp == version ) { gereversion $1 %nick %mess }

        println $1 3 <font color=red face="courier new" size=2> $chr(91) $+ %nick $upper(%ctcp) $+ $chr(93)
        printmirc $1 0 %mess 
        println $1 0 </font></font>

      }

      else {
        if ( %echo == oui ) {
          println $1 3 <font color=darkred face="courier new" size=2> * $+ %nick $+ * 
          printmirc $1 0 %mess 
          println $1 0 </font></font>  
        }   
        ildit $1 %nick %mess
      }
    }
  }

  elseif ( $regex(%temp,/^:(\S+) notice (\S+) :(.*)$/i) == 1 ) {
    %nick = $gettok($regml(1),1,33)
    %userhost = $gettok($regml(1),2,33)
    %chan = $regml(2)
    %mess = $regml(3)

    if ( $asc(%chan) == 35 || $asc(%chan) == 38 ) {

      ; Notice public

      println $1 3 <font color=darkred face="courier new" size=2> - $+ $prefix(%nick,$1) $+ : $+ %chan $+ - 
      printmirc $1 0 %mess 
      println $1 0 </font></font>
      noticer $1 5- $+ %nick $+ : $+ %chan - %mess
    }
    else {

      ; Notice privé

      if ($regsub(%mess,/^([^ ]+)/,,%mess) == 1 ) {
        %mess = $left(%mess,$calc($len(%mess)-1))
        %ctcp = $regml(1)
        if ( %ctcp == PING ) { %mess = $gerepreply($1,%nick,%mess) }

        println $1 3 <font color=red face="courier new" size=2><b> $chr(91) $+ %nick $upper(%ctcp) reply $+ $chr(93) </b>
        printmirc $1 0 %mess 
        println $1 0 </font></font>
        sendpriv $1 %nick 4[ $+ %nick $upper(%ctcp) reply $+ ] %mess
      }
      else {
        println $1 3 <font color=darkred face="courier new" size=2> - $+ %nick $+ - 
        printmirc $1 0 %mess 
        println $1 0 </font></font>
        noticer $1 5- $+ %nick $+ - %mess
      }
    }
  }

  elseif ( $regex(%temp,/^:(\S+) mode (\S+) (\S+)( .+)?$/i) == 1 ) { 
    %nick = $gettok($regml(1),1,33)
    %userhost = $gettok($regml(1),2,33)
    %chan = $regml(2)
    %modes = $regml(3)
    %liste = $regml(4)
    %liste = $right(%liste,$calc($len(%liste)-1))

    println $1 1 <font color= $+ %modecol $+ > $+ $liremess(23,%nick,%modes,%liste) </font>
    println $1 4 $domodes(%chan,%modes,%liste,$1)
    ; changement de mode
  }

  elseif ( $regex(%temp,/^:(\S+) nick :(\S+)/i) == 1 ) {
    %nick = $gettok($regml(1),1,33)
    %userhost = $gettok($regml(1),2,33)
    %newnick = $regml(2)

    if ( %newnick == %me ) {
      println $1 1 <font color= $+ %cnick $+ > $+ $liremess(24,%newnick) </font>
      validecontrol %cook
    }
    else {
      println $1 1 <font color= $+ %cnick $+ > $+ $liremess(25,%nick,%newnick) </font>
    }

    changepriv $1 %nick %newnick

    %signe = $signe(%nick,$1) | remni %nick $1 | addni %signe $+ %newnick $1

    %nick = $replace(%nick,\,\\)
    %nick = $replace(%nick,",\")
    %newnick = $replace(%newnick,\,\\)
    %newnick = $replace(%newnick,",\")

    println $1 4 <SCRIPT> change_member(" $+ %chan $+ "," $+ %nick $+ "," $+ %newnick $+ " $+ ) </SCRIPT>
    ; changement de nick
  }

  elseif ( $regex(%temp,/^:(\S+) topic (\S+) :(.+)?$/i) == 1 ) { 
    %nick = $gettok($regml(1),1,33)
    %userhost = $gettok($regml(1),2,33)
    %chan = $regml(2)
    %liste = $regml(3)

    println $1 3 <font color= $+ %modecol $+ > $+ $liremess(26,%nick) 
    printmirc $1 0 %liste 
    println $1 0 </font></font>
    println $1 6 <script> parent.topic("\
    printmirc $1 1 %liste
    println $1 6 "); </script>
    ; change le thème
  }

  elseif ( $regex(%temp,/^:(\S+) invite \S+ (\S+)?$/i) == 1 ) { 
    %nick = $gettok($regml(1),1,33)
    %userhost = $gettok($regml(1),2,33)
    %chan = $regml(2)

    println $1 1 <font color= $+ %cnick $+ > $+ $liremess(27,%nick,$smiley(%chan)) </font>
    ; invitation
  }
}

alias domodes {
  ; canal, modes, liste

  var %i, %N, %modes, %c, %temp, %nick

  %N = $gettok($3-,0,32)
  %i = 1
  %modes = $sepmode($2)
  %temp = <SCRIPT>

  while ( %i <= %N ) {
    %c = $mid(%modes,$calc(%i * 2 - 1),2)
    %nick = $gettok($3-,%i,32)

    %nick = $replace(%nick,\,\\)
    %nick = $replace(%nick,",\")

    if ( %c == +o ) { set %temp %temp $+ add_op(" $+ $1 $+ "," $+ %nick $+ "); | remni %nick $4 | addni @ $+ %nick $4 }
    elseif ( %c == -o ) { set %temp %temp $+ remove_op(" $+ $1 $+ "," $+ %nick $+ "); | remni %nick $4 | addni %nick $4 }
    elseif ( %c == +v ) { set %temp %temp $+ add_vo(" $+ $1 $+ "," $+ %nick $+ "); 
    if ($signe(%nick,$4) != @ ) { remni %nick $4 | addni + $+ %nick $4  } }
    elseif ( %c == -v ) { set %temp %temp $+ remove_vo(" $+ $1 $+ "," $+ %nick $+ "); 
    if ($signe(%nick,$4) != @ ) { remni %nick $4 | addni %nick $4  } }
    inc %i
  }
  %temp = %temp </SCRIPT>
  return %temp
}

alias addmembers {
  %cook = $right($2,$calc($len($2)-3))
  var %N = $gettok($4-,0,32)
  var %i = 1

  if ( $1 == 1 ) { dline -l @chat $+ %cook 1- }

  while ( %i <= %N ) {
    aline -l @chat $+ %cook $gettok($4-,%i,32)
    inc %i
  }
}

alias sendmembers {
  ; reset, socket, canal, liste nicks
  var %temp, %i, %N, %nick, %op
  var %cook = $right($2,$calc($len($2)-3))

  %temp = <SCRIPT> remove_all_members(" $+ $3 $+ ");

  %N = $line(@chat $+ %cook,0,1)

  %i = 1

  while ( %i <= %N ) {
    %nick = $line(@chat $+ %cook,%i,1)
    ;    %op = $regsub(%nick,/^@/,,%nick)
    ;    %vo = $regsub(%nick,/^\+/,,%nick)

    %nick = $replace(%nick,\,\\)
    %nick = $replace(%nick,",\")

    set %temp %temp $+ app_member(" $+ $3 $+ "," $+ %nick $+ ");
    ;    if ( %op == 1 ) {  set %temp %temp $+ add_op(" $+ $3 $+ "," $+ %nick $+ "); }
    ;    elseif ( %vo == 1 ) {  set %temp %temp $+ add_vo(" $+ $3 $+ "," $+ %nick $+ "); }
    if ( $len(%temp) > 800 ) {  %temp = %temp </SCRIPT> | println $2 4 %temp | %temp = <SCRIPT> }
    inc %i
  }

  %temp = %temp </SCRIPT>

  println $2 4 %temp
}

alias addmember {
  ; reset, socket, canal, liste nicks
  var %temp, %i, %N, %nick, %op
  var %cook = $right($2,$calc($len($2)-3))

  %nick = $4

  %nick = $replace(%nick,\,\\)
  %nick = $replace(%nick,",\")

  set %temp <script> add_member(" $+ $3 $+ "," $+ %nick $+ ");
  %temp = %temp </SCRIPT>

  println $2 4 %temp
}

alias delmember {
  ; socket, canal, nick
  var %temp, %i, %N, %nick, %op, %remop

  %nick = $3

  %nick = $replace(%nick,\,\\)
  %nick = $replace(%nick,",\")

  %temp = <SCRIPT> remove_member(" $+ $2 $+ "," $+ %nick $+ "); </SCRIPT>
  println $1 4 %temp
}


alias sepmode {
  var %N, %temp, %temp1, %temp2, %i

  %N = $len($1) | %i = 1 | %temp = + | set %temp1 $null
  while ( %i <= %N ) {
    %temp2 = $mid($1,%i,1)
    if ( %temp2 == + ) %temp = +
    elseif ( %temp2 == - ) %temp = -
    else %temp1 = %temp1 $+ %temp $+ %temp2
  inc %i }
  return %temp1
}

alias nettoie /unset %file* %stop* %packet* %pos*

alias ppp sockclose irc*

alias ouvreserv {
  var %j, %putain

  %cgras = $chr(2)
  %csoul = $chr(31)
  %cinve = $chr(22)
  %ccoul = $chr(3) 
  %cnorm = $chr(15)

  %gras = 0
  %souligne = 0
  %couleur = 0
  %inverse = 0

  echo 4 -s *** (Re)Hashing...
  set %col white black darkblue darkgreen red darkred darkmagenta orange yellow lightgreen darkcyan cyan blue magenta gray darkgray
  chatrehash

  %variables = $getvariable(0)
  %j = 1
  %NVar = $gettok(%variables,0,32)

  while ( %j <= %NVar ) {
    %putain = $gettok(%variables,%j,32)
    hadd -m variable %putain $getvariable(%putain)
    inc %j
  }

  %systemport = $variables(port)
  %changechan = $variables(changechan)
  %restrict = $variables(chanrestrict)
  %changenick = $variables(changenick)
  %couleurs = $variables(couleurs)
  %bantime = $variables(dureeban)
  %writelog = $variables(logs)
  %urls = $variables(clickurls)
  %raws = $variables(raw)
  %nicklist = $variables(listenicks)
  %quitte = $variables(quitmess)
  %signes = $variables(prefixe)
  %echo = $variables(echopriv)
  %fond = $variables(backcolor)
  %kick = $variables(kickcol)
  %join = $variables(joincol)
  %quit = $variables(quitcol)
  %action = $variables(actioncol)
  %moi = $variables(mecol)
  %modecol = $variables(modecol)
  %cnick = $variables(nickcol)
  %reg = $variables(regul)

  if ( $regex(%bantime,/^\d+$/) == 0 ) { %bantime = 60 }
  elseif ( %bantime < 1 ) { %bantime = 60 }

  %N = $lines(Webchat/smiles/smileys.ini)
  %i = 1

  while (%i <= %N ) {
    %rien = $regex($read -nl $+ %i Webchat/smiles/smileys.ini,/^(\S+)\s+(.+)$/)
    hadd -m smiles S $+ %i $regml(1)
    hadd smiles F $+ %i <img src=../smiles/ $+ $regml(2) $+ >
    inc %i
  }

  hadd smiles N %N

  if (!$portfree(%systemport)) { echo 2 -s *** $liremess(48,%systemport) }
  else {
    socklisten chatsys %systemport | echo 4 -s *** $liremess(49) | window -h @Webchat | titlebar @Webchat (Ne pas fermer cette fenêtre)
  }
}

alias fermeserv {
  .timer off | sockclose irc* | sockclose web* | sockclose chatsys | nettoie | echo 4 -s *** $liremess(50)
}

on 1:load: { if ($Version < 6.01) { echo 2 -a *** You must have mirc 6.01 or more to use this addon. (Download mirc on www.mirc.co.uk) | .timerunl 1 1 /unload -rs webchat.mrc | halt } 
  installe 
}

alias installe {
  var %reponse

  %reponse = $?!="Would you like to install the french version?" 
  if ( %reponse == $true ) {
    .copy -o Webchat/franco/*.* Webchat/
    .disable #anglo
    .enable #franco
    echo 4 -s L'installation est terminée!
    echo 4 -s Lis le fichier d'aide aide.txt pour toute question concernant cet addon
    echo 4 -s et pense a modifier le fichier config.ini. Voilà :)
  }
  else {
    .copy -o Webchat/anglo/*.* Webchat/
    .disable #franco
    .enable #anglo
    echo 4 -s Installation complete!
    echo 4 -s Read the file help.txt in the webchat folder for any question regarding this addon
    echo 4 -s and don't forget to modify the file config.ini. Enjoy :)
  }

}

on 1:start: {
  echo 12 -s Web Chat Server v 2.5 bilingual version - by Averell (2003-2004)
} 

#franco off

menu menubar {
  Web Chat Server
  .Ouvrir serveur: ouvreserv
  .Fermer serveur: fermeserv
  .Configuration: run Webchat/config.ini
  .Aide: run Webchat/aide.txt
}

#franco end

#anglo on

menu menubar {
  Web Chat Server
  .Open server: ouvreserv
  .Close server: fermeserv
  .Configuration: run Webchat/config.ini
  .Help: run Webchat/help.txt
}

#anglo end

alias printmirc {
  var %exp, %rien, %texte, %html, %temp
  var %cook, %chat, %chan, %nick, %br, %time, %time2, %i, %N
  var %putain = />\s/g

  ; $2 = 0 en mode html, 1 en mode javascript , 2 pour ecrire dans tous les logs privés
  ; >2 en mode privé (log sur %cook)

  %cook = $right($1,$calc($len($1)-3)) 
  %chat = $hget(hirc $+ %cook,CHAT)
  if ( $sock(%chat).name == $null ) return

  %temp = $replace($3-,$chr(36),$chr(27),\,$chr(28))

  %texte = $smiley(%temp)

  if (%couleurs != oui ) { %texte = $strip(%texte) }

  %exp = /(||||)(\d+)?(,\d+)?/e

  while ( $regex(%texte,%exp) == 1 ) {

    if ($len(%texte) > 500 ) {
      %html = $left(%texte,$calc($regml(1).pos - 1))
      %texte = $right(%texte,$calc($len(%texte) - $len(%html)))
      %rien = $regsub(%html,/> /g,>&nbsp;,%html)
      if ( %html != $null ) { 
        %html = $replace(%html,$chr(27),$chr(36),$chr(28),\)
        if ( $2 != 0 ) { 
          %html2 = %html
          %html = $replace(%html,\,\\,",\")
          %html = %html $+ \

          if ( $2 > 2 ) { write Webchat/logs/priv $+ $2 $+ .htm %html2 }
          elseif ($2 == 2 ) {
            %N = $hget(id $+ %cook,N)
            %i = 1

            while ( %i <= %N ) {
              write Webchat/logs/priv $+ $hget(id $+ %cook,C $+ %i) $+ .htm %texte2
              inc %i
            }
          }

        }
        println $1 $iif($2 == 0,2,6) %html 
      }      
    }

    %rien = $regsub(%texte,%exp,$traitemirc($regml(1),$regml(2),$regml(3)),%texte)
  }

  %rien = $regsub(%texte,/> /g,>&nbsp;,%texte)
  %texte = %texte $+ $normal
  %texte = $replace(%texte,$chr(27),$chr(36),$chr(28),\) 
  if ( $2 != 0 ) { 
    %texte2 = %texte
    %texte = $replace(%texte,\,\\,",\")
    %texte = %texte $+ \
    if ( $2 > 2 ) { write Webchat/logs/priv $+ $2 $+ .htm %texte2 }
    elseif ($2 == 2 ) {
      %N = $hget(id $+ %cook,N)
      %i = 1

      while ( %i <= %N ) {
        write Webchat/logs/priv $+ $hget(id $+ %cook,C $+ %i) $+ .htm %texte2
        inc %i
      }
    }

  }
  println $1 $iif($2 == 0,2,6) %texte
}

alias couleur {
  var %supp, %font, %d2, %rien, %exp, %S, %un, %deux

  %exp = /^,/

  if ($1 == $null && $2 == $null) { 
    %S = $null 
    %i = 0
    while ( %i < %couleur ) { %S = %S $+ </font> | inc %i } 
    set %couleur 0
    return %S
  }
  %font = $iif(%couleur > 0,</font>)
  %font = $null
  inc %couleur

  ;  echo 3 -s un = $1 et 2 = $2
  if ($2 == $null && $asc($1) != 44) { return %font $+ <font color= $+ $gettok(%col,$calc(($1 % 16) + 1),32) $+ > }

  %d2 = $iif($asc($1) == 44,$1,$2)
  %rien = $regsub(%d2,%exp,,%d2)
  %supp = $iif($1 != $null, color= $+ $gettok(%col,$calc(($1 % 16) + 1),32) $+ >,>)
  return %font $+ <font style="background-color: $+ $gettok(%col,$calc((%d2 % 16) + 1),32) $+ ;" %supp
}

alias gras {
  %gras = $calc(1 - %gras)
  return $iif(%gras > 0,<b>,</b>)
}

alias souligne {
  %souligne = $calc(1 - %souligne)
  return $iif(%souligne > 0,<u>,</u>)
}

alias inverse {
  %inverse = $calc(1 - %inverse)
  if ( %inverse > 0 ) { return <font style="background-color:black;" color=white> }
  else return </font>
}

alias normal {
  var %i, %S

  %i = 0
  %S = $null

  while ( %i < $calc(%couleur + %inverse) ) { %S = %S $+ </font> | inc %i }
  if ( %gras > 0 ) { %S = %S $+ </b> }
  if ( %souligne > 0 ) { %S = %S $+ </u> }

  %gras = 0
  %souligne = 0
  %couleur = 0
  %inverse = 0

  return %S
}

alias traitemirc {
  ; return
  if ($1 == %cgras) { return $gras $+ $2 $+ $3 }
  elseif ($1 == %csoul) { return $souligne $+ $2 $+ $3 }
  elseif ($1 == %cinve) { return $inverse $+ $2 $+ $3 }
  elseif ($1 == %cnorm) { return $normal $+ $2 $+ $3 }
  elseif ($1 == %ccoul) { return $couleur($2, $3) }
}

alias smiley {
  var %i, %N
  var %exp1 = /(http:\/\/\S+)/e
  var %exp2 = /(^|[^a-zA-Z\/])(www\.\S+)/e
  var %exp3 = /(^|[ @+%*])(#\S+)/

  var %texte = $1-

  %texte = $replace(%texte,&,&amp;)
  %texte = $replace(%texte,<,&lt;)
  %texte = $replace(%texte,$chr(36),$chr(26)) 

  %N = $hget(smiles,N)
  %i = 1

  while ( %i <= %N) {
    %texte = $replace(%texte,$hget(smiles,S $+ %i),$hget(smiles,F $+ %i) )
    inc %i
  }

  if ( %urls == oui ) {
    while ( $regex(URL,%texte,%exp1) == 1 ) {
      %rien = $regsub(URL,%texte,%exp1,$urleval($regml(URL,1)),%texte)
    }

    while ( $regex(URL,%texte,%exp2) == 1 ) {
      %rien = $regsub(URL,%texte,%exp2, $regml(URL,1) $+ $urleval($regml(URL,2)),%texte)
    }

    %texte = $replace(%texte,$chr(29),http,$chr(30),www)
  }

  if ( %changechan == oui && %restrict != oui ) {
    while ( $regex(URL,%texte,%exp3) == 1 ) {
      %rien = $regsub(URL,%texte,%exp3,$regml(URL,1) $+ $chaneval($regml(URL,2)),%texte)
    }

    %texte = $replace(%texte,$chr(29),$chr(35))
  }

  %texte = $replace(%texte,$chr(26),$chr(36))
  return %texte
}

alias chaneval {
  var %chan = $replace($1,$chr(35),% $+ 23)
  %chan = $replace(%chan,&,% $+ 26)
  %chan = $replace(%chan,+,% $+ 2B)

  var %texte = <a href=/html/menu.html?C= $+ %chan target=menu> $+ $1 $+ </a>
  return $replace(%texte,$chr(35),$chr(29))
}

alias urleval {
  var %h = $iif($left($1,4) != http,http://)
  var %d1 = $strip($1-)

  %rien = $regsub(URL,%d1,/(\W+)$/,,%d1)

  var  %texte = <a href= $+ %h $+ %d1 target=_blank> $+ %d1 $+ </a> $+ $regml(URL,1)
  return $replace(%texte,http,$chr(29),www,$chr(30))
}

alias chatrehash {
  var %N, %i, %x, %c

  %c = 1

  %N = $lines(Webchat/config.ini)
  %i = 1

  while ( %i <= %N ) {
    %x = $read -nl $+ %i Webchat/config.ini
    if ( %x != $null && $left(%x,1) != ; ) {
      hadd -m config C $+ %c %x | hadd config C %c 
      inc %c 
    }
    inc %i
  }

}

alias serveurs {
  var %temp, %N, %i, %j

  %temp = $null

  %N = $hget(config,C)
  %i = 1
  %j = 1

  while ( %i <= %N ) {
    if ( $regex($hget(config,C $+ %i),/^(\w[^:]*):\s*([\w.-]+):(\d+)/)) {
      if ( $1 == 0 ) {      %temp = %temp <option value= $+ %j $+ > $+ $regml(1) }
      elseif ( $1 == %j ) { %temp = $regml($calc($2 + 0)) }
      inc %j
    }
    inc %i
  }
  return %temp
}

alias canaux {
  var %temp, %N, %i, %j

  %temp = $null

  %N = $hget(config,C)
  %i = 1
  %j = 1

  while ( %i <= %N ) {
    if ( $regex($hget(config,C $+ %i),/^(#\S+)/)) {
      if ( $1 == 0 ) { %temp = %temp <option> $+ $regml(1) }
      elseif ( $1 == %j ) { %temp = $regml(1) }
      inc %j
    }
    inc %i
  }
  return %temp
}

alias slaps {
  var %temp, %N, %i, %j

  %temp = <option> Liste d'actions

  %N = $hget(config,C)
  %i = 1
  %j = 0

  while ( %i <= %N ) {
    if ( $regex($hget(config,C $+ %i),/^\.([^:]+):(.+)$/)) {
      %temp = <option value=" $+ $subst(0,$regml(2)) $+ "> $+ $subst(0,$regml(1)) 
      inc %j
      hadd -m _slaps C $+ %j %temp
      ;      if ( $1 == %j ) { return %temp }
    }
    inc %i
  }
  hadd _slaps N %j
  return %j
}

alias commandes {
  var %temp, %N, %i, %j

  %temp = <option> Commandes

  %N = $hget(config,C)
  %i = 1
  %j = 0

  while ( %i <= %N ) {
    if ( $regex($hget(config,C $+ %i),/^\/([^:]+): *(.+)$/)) {
      %temp = <option value=' $+ $subst(0,$regml(2)) $+ '> $+ $subst(0,$regml(1)) 
      inc %j
      hadd -m _commandes C $+ %j %temp
      ;      if ( $1 == %j ) { return %temp }
    }
    inc %i
  }
  hadd _commandes N %j
  return %j
}

alias getvariable {
  var %temp, %N, %i,%truc

  %N = $hget(config,C)
  %temp = $null
  %i = 1

  while ( %i <= %N ) {
    if ( $regex(VAR,$hget(config,C $+ %i),/^\$([^=]+)=(.+)$/)) { 
      %truc = $gettok($regml(VAR,1),1,32)
      if ($1 == 0) { %temp = %temp %truc }
      if ( $1 == %truc ) { return $subst(0,$regml(VAR,2)) }
    }
    inc %i
  }
  if ($1 == 0) { return %temp }
}

alias variables {
  return $hget(variable,$1)
}

alias joindreserv {
  var %local, %distant, %ircport, %irchost

  %irchost = $variables(irchost)
  %ircport = $variables(ircport)

  %local = <script>  document.writeln('<B>IRC CLIENTS: '+document.location.hostname+' <i>port %ircport $+ </i></b><br>'); </script>
  %distant = <B>IRC CLIENTS: %irchost <i>port %ircport $+ </i></b><br>

  if ( %irchost == $null || %irchost == null ) { return }

  return $iif(%irchost == localhost || %irchost == 127.0.0.1,%local,%distant)
}

alias gereping {
  sockwrite -nt $1 NOTICE $2 :PING $3 $+ 
}

alias gereversion {
  sockwrite -nt $1 NOTICE $2 :VERSION $variables(version) $+ 
}

alias gerepreply {
  return $duration($calc($ctime - $3))
}

alias liremess {
  var %temp
  var %d1- = $chr(36) $+ 1-
  var %d1 = $chr(36) $+ 1

  var %d2- = $chr(36) $+ 2-
  var %d2 = $chr(36) $+ 2

  var %d3- = $chr(36) $+ 3-
  var %d3 = $chr(36) $+ 3

  var %d4- = $chr(36) $+ 4-
  var %d4 = $chr(36) $+ 4

  %temp = $read -nl $+ $1 Webchat/messages.ini
  %temp = $replace(%temp,%d1-,$2-,%d1,$2,%d2-,$3-,%d2,$3,%d3-,$4-,%d3,$4,%d4-,$5-,%d4,$5)
  return %temp
}

alias assigne {
  var %cook = $right($1,$calc($len($1)-3))
  var %size = $hget(id $+ %cook,N)

  if ( %size == $null ) { %size = 0 }

  ; socket, nick . Retourne l'id

  var %x = $hget(priv $+ %cook,$2)

  if ( %x == $null ) {
    %x = $ticks
    hadd priv $+ %cook $2 %x
    hadd priv $+ %cook %x $2
    inc %size
    hadd id $+ %cook N %size
    hadd id $+ %cook C $+ %size %x
  }

  return %x
}

alias changepriv {

  var %cook2 = $right($1,$calc($len($1)-3))
  var %cook = $hget(priv $+ %cook2,$2)
  if ( %cook == $null ) { return }

  hdel priv $+ %cook2 $2
  hadd priv $+ %cook2 $3 %cook
  hadd priv $+ %cook2 %cook $3

  write Webchat/logs/priv $+ %cook $+ .htm <font color= $+ %cnick $+ >* $2 $liremess(37) $3 </font><br>

}

alias sendpriv {
  var   %cook2 = $right($1,$calc($len($1)-3))
  if ($hget(priv $+ %cook2,$2) == $null ) { return }

  var %cook = $assigne($1,$2)

  println $1 6 <script> parent.jedis( $+ %cook $+ ,"\
  printmirc $1 %cook $3-
  println $1 6 "); </script>
  write Webchat/logs/priv $+ %cook $+ .htm <br>

}

alias ildit {
  var %time = $left($time,5)
  var %cook = $assigne($1,$2)
  var %nick = $replace($2,\,\\,",\")

  println $1 6 <script> parent.ildit(" $+ %nick $+ ", $+ %cook $+ ,"<font face='courier new' size=2 color= $+ %reg $+ ><font color=darkgray>[ $+ %time $+ ]</font> <b>&lt; $+ %nick $+ &gt;</b> \
  write Webchat/logs/priv $+ %cook $+ .htm <font face='courier new' size=2 color= $+ %reg $+ ><font color=darkgray>[ $+ %time $+ ]</font> <b>&lt; $+ $2 $+ &gt;</b>
  printmirc $1 %cook $3-
  println $1 6 </font>"); </script>
  write Webchat/logs/priv $+ %cook $+ .htm </font><br>
}

alias ilmedit {
  var %time = $left($time,5)
  var %cook = $assigne($1,$2)
  var %nick = $replace($2,\,\\,",\")

  println $1 6 <script> parent.ildit(" $+ %nick $+ ", $+ %cook $+ ,"<font face='courier new' size=2><font color=darkgray>[ $+ %time $+ ]</font><font color= $+ %action $+ > * %nick \
  write Webchat/logs/priv $+ %cook $+ .htm <font face='courier new' size=2><font color=darkgray>[ $+ %time $+ ]</font><font color= $+ %action $+ > * $2
  printmirc $1 %cook $3-
  println $1 6 </font></font>"); </script>
  write Webchat/logs/priv $+ %cook $+ .htm </font></font><br>
}

alias jedis {
  var %time = $left($time,5)
  var %cook = $assigne($1,$2)
  var %cook2 = $right($1,$calc($len($1)-3))
  var %me = $hget(hirc $+ %cook2,NICK)

  println $1 6 <script> parent.jedis( $+ %cook $+ ,"<font face='courier new' size=2><font color=darkgray>[ $+ %time $+ ]</font> <b><font color= $+ %moi $+ >&lt; $+ %me $+ &gt;</b> \
  write Webchat/logs/priv $+ %cook $+ .htm <font face='courier new' size=2><font color=darkgray>[ $+ %time $+ ]</font> <font color= $+ %moi $+ ><b>&lt; $+ %me $+ &gt;</b>
  printmirc $1 %cook $3-
  println $1 6 </font></font>"); </script>
  write Webchat/logs/priv $+ %cook $+ .htm </font></font><br>
}

alias jeluidis {
  var %time = $left($time,5)
  var %cook = $assigne($1,$2)
  var %cook2 = $right($1,$calc($len($1)-3))
  var %me = $hget(hirc $+ %cook2,NICK)

  println $1 6 <script> parent.jedis( $+ %cook $+ ,"<font face='courier new' size=2><font color=darkgray>[ $+ %time $+ ]</font><font color= $+ %moi $+ > * %me \
  write Webchat/logs/priv $+ %cook $+ .htm <font face='courier new' size=2><font color=darkgray>[ $+ %time $+ ]</font><font color= $+ %moi $+ > * %me

  printmirc $1 %cook $3-
  println $1 6 </font></font>"); </script>
  write Webchat/logs/priv $+ %cook $+ .htm </font></font><br>
}

alias noticer {
  var %time = $left($time,5)
  var %cook
  var %cook2 = $right($1,$calc($len($1)-3))

  var %i = 1
  var %N = $hget(id $+ %cook2,N)

  while ( %i <= %N ) {
    %cook = $hget(id $+ %cook2,C $+ %i)
    write Webchat/logs/priv $+ %cook $+ .htm <font face='courier new' size=2><font color=darkgray>[ $+ %time $+ ]</font>
    inc %i
  }

  println $1 6 <script> parent.notice("<font face='courier new' size=2><font color=darkgray>[ $+ %time $+ ]</font> \
  printmirc $1 2 $2-
  println $1 6 </font>"); </script>

  %i = 1

  while ( %i <= %N ) {
    %cook = $hget(id $+ %cook2,C $+ %i)
    write Webchat/logs/priv $+ %cook $+ .htm </font><br>
    inc %i
  }
}

alias addni { 
  var %cook = $right($2,$calc($len($2)-3)) 
  var %NomWin @chat $+ %cook

  aline -l %NomWin $1
}

alias remni remnick $1 $2 | remnick @ $+ $1 $2 | remnick + $+ $1 $2

alias remnick {
  var %cook = $right($2,$calc($len($2)-3)) 
  var %NomWin @chat $+ %cook
  var %i = 1

  :next
  if ( %i > $line(%NomWin,0,1)) goto fin2
  %temp = $line(%NomWin,%i,1))
  if ( $1 == %temp )  goto fin
  inc %i
  goto next
  :fin
  dline -l %NomWin %i
  :fin2
}

alias signe {
  var %cook = $right($2,$calc($len($2)-3)) 
  var %NomWin = @chat $+ %cook
  var %i = 1 
  var %temp, %signe, %signe1, %c

  set %signe $null
  set %signe1 $null

  :next
  if ( %i > $line(%NomWin,0,1)) goto fin2
  %temp = $line(%NomWin,%i,1)) 

  %c = $left(%temp,1)
  if ( %c != @ && %c != + ) { set %nick1 %temp | set %signe1 $null }
  else { set %signe1 %c | set %nick1 $right(%temp,$calc($len(%temp) - 1)) }

  if ( $1 == %nick1 )  goto fin
  inc %i
  goto next
  :fin
  %signe = %signe1
  :fin2
  return %signe
}

alias isonchat {
  var %cook = $right($2,$calc($len($2)-3)) 
  var %NomWin = @chat $+ %cook
  var %i = 1 
  var %temp, %nick1, %c

  set %trouve $false

  :next
  if ( %i > $line(%NomWin,0,1)) goto fin2
  %temp = $line(%NomWin,%i,1)) 

  %c = $left(%temp,1)
  if ( %c != @ && %c != + ) { set %nick1 %temp }
  else { set %nick1 $right(%temp,$calc($len(%temp) - 1)) }

  if ( $1 == %nick1 )  { set %trouve $true | goto fin2 }
  inc %i
  goto next
  :fin2
  return %trouve
}

alias prefix return $iif(%signes == oui,$signe($1,$2) $+ $1,$1)
