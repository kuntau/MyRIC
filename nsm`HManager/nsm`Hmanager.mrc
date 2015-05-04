alias hmanager { dialog $+(-,$iif($dialog(hm),ev,dm)) hm hm }
alias zxr {
  if $dialog(hm) {
    dialog -x hm
    dialog -dm hm hm 
  }
  else {
    dialog -dm hm hm
  }
}
dialog -l hm {
  title Hash Table Manager v1.7 [[ /HManager ]]
  size -1 -1 308 165
  option dbu
  icon $î(board)
  button "Ok", 1, 190 83 40 15, ok, hide
  button "Cancel", 2, 232 83 40 15, cancel, hide
  text "Hash table name:", 3, 62 8 50 12
  combo 4, 110 5 105 50, size
  button "Refresh !", 5, 219 5 30 12
  list 6, 60 20 190 78, size
  box "", 7, 253 2 50 96
  text "", 8, 254 8 48 88, center, disable
  box "Hash table editor", 9, 60 100 243 48
  list 10, 60 150 243 10, size
  list 11, 260 133 40 10, size
  check Ontop, 12, 265 135 25 10, center
  text ~Künt@ü~ $crlf $+ 31.10.2003, 13, 257 118 40 12, center, disable
  box "", 14, 253 100 50 48
  combo 15, 256 106 44 9, drop
  button Undo, 16, 167 134 40 10
  button Proceed !, 17, 209 134 40 10
  text Name:, 18, 64 111 15 10
  text Item:, 19, 115 111 15 10
  text Value:, 20, 64 123 15 10
  text Switch:, 21, 64 135 18 10
  edit "", 22, 83 110 30 10, autohs
  edit "", 23, 130 110 120 10, autohs
  edit "", 24, 83 122 167 10, autohs
  edit "", 25, 83 134 80 10, autohs
  edit "", 26, 1 1 1 1, autohs, hide
  ;icon 27, 230 130 16 16, $î(help), noborder
  list 27, 5 20 50 78, size, extsel
  menu "File", 50
}
on *:load:{
  var %hm $input(Thank you for using Hash Table Manager ! $crlf $crlf $+ Hit yes if you want to launch readme file or no to continue using ... ,yi,Thanx !)
  if (%hm) { run " $+ $scriptdirreadme !.txt $+ " } | hmanager
}
on *:dialog:hm:init:0:{
  ø SetMircVersion $version | ø MarkDialog hm | ø SetDialog hm style border title sysmenu minbox
  ø SetControlMDX 4 ComboBoxEx drop > $Þ | ø SetControlMDX 6 ListView headerdrag report rowselect showsel single infotip nosortheader > $Þ
  ø SetControlMDX 27 ListView report rowselect infotip editlabels single headerdrag showsel nosortheader > $Þ
  ø SetControlMDX 10 StatusBar > $ô | ø SetControlMDX 11 toolbar flat list nodivider arrows > $ô
  ø SetBorderStyle 10 windowedge | ø SetBorderStyle 11
  ø SetFont 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,27 12 700 tahoma
  did -i hm 4 1 iconsize small | did -i hm 4 1 seticon 0 $î(0,board)
  did -i hm 6 1 headerdims 35 100 240 | did -i hm 6 1 headertext No. $chr(9) Item $chr(9) Value
  did -i hm 27 1 headerdims 95 | did -i hm 27 1 headertext Hash Table
  did -i hm 10 1 seticon list $î(0,list) | did -i hm 10 2 1 Status bar
  did -i hm 11 1 bmpsize 16 16 | did -i hm 11 1 setimage +nhd icon small $î(0,out)
  did -a hm 15 hadd | did -a hm 15 hdel | did -a hm 15 hsave | did -a hm 15 hload | did -a hm 15 hmake | did -a hm 15 hfree
  did -c hm 15 1 | did -b hm 16 | á | ñ.à
}
on *:dialog:hm:sclick:*:{
  if ($did == 4) à
  if ($did == 5) á $did(4).sel
  if ($did == 6) { var %i $right($left($did(15),2),1) | ä $iif(%i = m,0,1) $iif(%i = a || %i = d ,1,0) $iif(%i = a,1,0) 1 | å $right($left($did(15),2),1) }
  if ($did == 15) ã
  if ($did == 16) { var %c 22 | while (%c <= 26) { did -ra hm %c $hget(hm,%c) | inc %c } | did -b hm 16 | ã }
  if ($did == 17) {
    var %i $right($left($did(15),2),1) | $did(15) $iif($did(25),$+(-,$ifmatch)) $did(22) $did(23) $did(24) 
    if (%i == m) || (%i == l) || (%i == f) { á $iif(%i == m,$calc($did(4).lines + 1),$iif(%i == l,$did(4).lines)) }
    if (%i == a) || (%i == d) { à $iif($did(6).sel,$ifmatch) }
  }
  if ($did == 11) { var %op $right($did(15),4), %hm.file = $sfile(*.*,Select hash table file to %op,Select) | if (%hm.file) { did -ra hm 23 %hm.file | å $right($left($did(15),2),1) } }
  if ($did == 12) dialog $+(-,$iif($did($did).state,o,n)) hm hm
  ;if ($did == 27) { run " $+ $scriptdirreadme !.txt $+ " }
}
on *:dialog:hm:edit:22,23,24,25:{ â $did(15) $iif($did(25),$+(-,$ifmatch)) $did(22) $did(23) $did(24) | did $+(-,$iif($did($did) === $hget(hm,$did),b,e)) hm 16 | å $right($left($did(15),2),1) }
on *:dialog:hm:close:*:$iif($hget(hm),hfree $ifmatch)
alias -l à {
  var %t $hget(0), %h $gettok($did(hm,4),5,32), %s $hget(%h).size, %i $hget(%h,0).item, %c 1, %r $crlf, %u $str(—,17), %x $right($left($did(15),2),1)
  did -r hm 6 | did -ra hm 8 $+(Hash Info %r,%u %r,Total : %t %r %u - Properties - %u %r,Name: %h %r %r Size: %s %r %r Total item: %i)
  while (%c <= %i) { did -a hm 6 $+(%c,$chr(46)) $chr(9) $hget(%h,%c).item $chr(9) $hget(%h,%c).data | inc %c }
  if ($did(6).lines >= 2) { did -c hm 6 $iif($1,$ifmatch,2) | ä $iif(%x = m,0,1) $iif(%x = a || %x = d ,1,0) $iif(%x = a,1,0) 1 } | ã
}
alias -l ñ.à {
  did -r hm 27 
  var %t $hget(0), %c 1 
  ;if (!%t) { did -ra hm 8 No hash table detected | ã | halt } 
  while (%c <= %t) { did -a hm 27 1 1 0 0 $hget(%c) | inc %c } 
  ;did -c hm 4 $iif($1,$ifmatch,2) 
  ;à $iif($2,$ifmatch)
}
alias -l á { did -r hm 4,6 | var %t $hget(0), %c 1 | if (!%t) { did -ra hm 8 No hash table detected | ã | halt } | while (%c <= %t) { did -a hm 4 1 1 0 0 $hget(%c) | inc %c } | did -c hm 4 $iif($1,$ifmatch,2) | à $iif($2,$ifmatch) }
alias -l â { did -i hm 10 2 1 $1- }
alias -l ã {
  var %e did -e hm, %b did -b hm, %r did -ra hm, %h did -h hm, %v did -v hm, %i $did(15)
  %e 17,18,19,20,21,22,23,24,25 | %r 19 Item: | %r 22,23,24,25 | %h 11 | %v 12
  if (%i == hadd) { $ä(1,1,1,1) } | if (%i == hdel) { %b 20,24 | $ä(1,1,0,0) }
  if (%i == hsave) || (%i == hload) { %r 11 +ra 1 Browse $chr(9) Browse file to $right($did(15),4) | %v 11 | %h 12 | %b 20,24 | %r 19 File: | $ä(1,0,0,0) }
  if (%i == hmake) { %r 19 Slot: | %b 20,24 | $ä(0,0,0,0) } | if (%i == hfree) { %b 19,20,23,24 | $ä(1,0,0,0) }
  $iif($did(4) && !$did(6).sel && %i != hmake,$ä(1,0,0,0)) | å $right($left(%i,2),1)
}
alias -l ä {
  var %h $gettok($did(4),5,32), %t $did(6).seltext, %i $gettok($gettok(%t,2,9),5,32), %v $gettok($gettok(%t,3,9),5-,32)
  $iif($1 && %h,did -ra hm 22 %h) | $iif($2,did -ra hm 23 %i) | $iif($3,did -ra hm 24 %v) | $iif($4,did -r hm 25)
  var %c 22 | while (%c < 26) { hadd -m hm %c $did(%c) | inc %c }
  â $did(15) $did(22) $iif($did(25),$+(-,$ifmatch)) $did(23) $did(24)
}
alias -l å {
  var %n $did(22), %i $did(23), %v $did(24), %s $did(25), %f, %sb, %x Hash table " $+ %n $+ " does not exists, %z Invalid switch " $+ %s $+ ", %y Invalid slot " $+ %i $+ ", %w Hash table " $+ %n $+ " already exists
  var %q File " $+ %i $+ " already exists $+ $chr(44) check your switch, %p File " $+ %i $+ " does not exists, %k Item " $+ %i $+ " does not exists
  if ($1 == a) { %f = $iif(%n && %i && %v,e,b) | if (%f == e) { $iif(m !isincs %s && !$hget(%n),%sb = %x,$iif(%s && $û(a,%s),%sb = %z)) } }
  if ($1 == d) { %f = $iif(%n && %i,e,b) | if (%f == e) { $iif(!$hget(%n),%sb = %x,$iif($hget(%n) && !$hfind(%n,%i) && w !isincs %s,%sb = %k,$iif(%s && $û(n,%s),%sb = %z))) } }
  if ($1 == s) { %f = $iif(%n && %i,e,b) | if (%f == e) { $iif(!$hget(%n),%sb = %x,$iif($isfile(%i) && %s !isincs ao,%sb = %q,$iif(%s && $û(s,%s),%sb = %z))) } }
  if ($1 == l) { %f = $iif(%n && %i,e,b) | if (%f == e) { $iif(!$hget(%n),%sb = %x,$iif(!$isfile(%i),%sb = %p,$iif(%s && $û(L,%s),%sb = %z))) } }
  if ($1 == m) { %f = $iif(%n,e,b) | if (%f == e) { $iif($hget(%n),%sb = %w,$iif(%i && %i !isnum,%sb = %y,$iif(%s && s !isincs %s,%sb = %z))) } }
  if ($1 == f) { %f = $iif(%n,e,b) | if (%f == e) { $iif(!$hget(%n) && w !isincs %s,%sb = %x,$iif(%s && $û(n,%s),%sb = %z)) } }
  $iif(%sb,%f = b) | did $+(-,%f) hm 17 | $iif(%f == b,â $iif(%sb,$ifmatch,Not Enough Parameter))
}
menu menubar {
  Hash Manager:Hmanager
}
alias -l û { var %c 1 | while (%c <= $len($2-)) { $iif($mid($left($2-,%c),%c) !isincs $iif($1 == a,smbczu0123456789,$iif($1 == L,sbni,$iif($1 == s,sbnioau,sw))),return 1) | inc %c } }
alias -l ø return $dll($+(",$scriptdirmdx\mdx.dll,"),$1,$2-)
alias -l ô return $scriptdirmdx\bars.mdx
alias -l Þ return $scriptdirmdx\views.mdx
alias -l î return $iif($2,$+($1,$chr(44),$scriptdiricon\,$2,.ico),$+(",$scriptdiricon\,$1,.ico,"))
