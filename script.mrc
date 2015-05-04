alias -l _loadaddons {
var %x = 0
while (%x < $findfile($1-,*.mrc,0)) {
  inc %x
  var %a,%name,%version,%desc
  %a = $findfile($1-,*.mrc,%x) | %name = $read(%a,s,;NAME) | %author = $read(%a,s,;AUTHOR) | %version = $read(%a,s,;VERSION) | %desc = $read(%a,s,;COMMENT)
  did -a $dname 1 0 0 0 $iif($script(%a) != $null,2,1) %name  $chr(9) %author $chr(9) %version $chr(9) %desc $chr(4) %a
}
unset %author
}
alias -l add did -a $dname 2 $1-
alias -l comdx did -i $dname 2 1 $1-
alias -l addtok var %i = 1 | while $gettok($2-,%i,$1) { did -a $dname 2 $ifmatch | inc %i }
alias -l _lang.module { did -a $dname 2 $_lang($dname,2) | did -a $dname 3 $_lang($dname,3) | dialog -t $dname $_lang($dname,topic) }
alias -l update.snd.list {
var %i = 2
while ($did(G.Settings,990,%i)) {
  if ($gettok($did(G.Settings,990,%i),5,32) == 2) { 
    writeini $sounds_ini $gettok($did(G.Settings,990,%i),-6,32) Status on 
  }
  else { writeini $sounds_ini $gettok($did(G.Settings,990,%i),-6,32) Status off }
  inc %i
}
}
alias cpanel { _dialog panel }
alias validchan { return $regex($1-,^#[\S]+([\s][\S]+|)$) }
alias snd.play { if ($did($dname,990).sel != $null) && ($chr(45) != $gettok($did($dname,990,$did(990).sel),12,32)) { var %a $readini($sounds_ini,$gettok($did($dname,990,$did(990).sel),-6,32),sound) | .splay -q %a } }
alias snd.edit {
  if ($did($dname,990).sel != $null) {
    var %file = $sfile($mircdir,Select A Music File,ok)
    if (%file == $null) { 
      writeini $sounds_ini $gettok($did($dname,990,$did(990).sel),-6,32) Sound $chr(45)
      did -o $dname 990 $did(990).sel 0 0 0 1 $gettok($did($dname,990,$did(990).sel),-6,32) $chr(9) $chr(45)
    }
    elseif ($right(%file,4) == .wav || $right(%file,4) == .mid || $right(%file,4) == .mp3) {
      writeini $sounds_ini $gettok($did($dname,990,$did(990).sel),-6,32) Sound %file
      did -o $dname 990 $did(990).sel 0 0 0 2 $gettok($did($dname,990,$did(990).sel),-6,32) $chr(9) $nopath(%file)
    }
    else { echo -a Please Select Only .wav or .mp3 or .mid audio files. }
  }
}
;
;edit ident
;
dialog ident.edit {
  title "Edit"
  size -1 -1 150 93
  option dbu
  button "&Ok",1, 115 80 30 12, default ok
  button "&Cancel",11, 85 80 30 12, cancel
  box "Edit", 2, 3 3 144 75
  edit "", 3, 42 12 100 11, autohs
  edit "", 4, 42 28 100 11, autohs
  edit "", 5, 42 45 100 11, autohs
  edit "", 6, 42 61 100 11, autohs

  text "Nick ", 7, 10 14 30 11
  text "Network ", 8, 10 30 30 11
  text "Command ", 9, 10 47 30 11
  text "Password ", 10, 10 63 30 11
}
on *:dialog:ident.edit:init:*: {
  mdx_mark
  mdx_call SetDialog $dname icon 76 $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
  mdx_call SetFont $dname 2 +a 15 900 verdana
  mdxfonts $dname 1,11,2,3,4,5,6,7,8,9,10
  ; mdx_call SetBorderStyle $dname 3,4,5,6 staticedge
  did -a $dname 2 Edit info for %identify.nick
  did -a $dname 3 %identify.nick
  did -a $dname 4 %identify.net
  did -a $dname 5 %identify.com
  did -a $dname 6 %identify.pass
}
on *:dialog:ident.edit:sclick:1: {
  if (*#* iswm %addnet.2) || (*;* iswm %addnet.2) || (*$* iswm %addnet.2) || (*^* iswm %addnet.2) || (*&* iswm %addnet.2) { 
    ident.error Can't add simbols in network name. $chr(40) $+ %addnet.2 $+ $chr(41) | halt 
  }
  elseif (*#* iswm %addcom.2) || (*;* iswm %addcom.2) || (*$* iswm %addcom.2) || (*^* iswm %addcom.2) || (*&* iswm %addcom.2) { 
    ident.error Can't add simbols in identify commands. $chr(40) $+ %addcom.2 $+ $chr(41) | halt 
  }
  else { 
    remini $mircdirNetworks/ $+ %identify.net $+ .ini %identify.nick
    writeini $mircdirNetworks/ $+ %addnet.2 $+ .ini %addnick.2 password %addpass.2
    writeini $mircdirNetworks/ $+ %addnet.2 $+ .ini %addnick.2 command %addcom.2
    writeini $mircdirNetworks/ $+ %addnet.2 $+ .ini %addnick.2 status on
    did -r G.Settings 31
    autoident.load
  }
}

;--------
;edit join
;--------

dialog join.edit {
  title "Edit - auto join"
  size -1 -1 150 83
  option dbu
  button "",1, 115 68 30 12, default ok
  button "",11, 85 68 30 12, cancel
  box "", 2, 3 3 144 62
  edit "", 3, 42 12 100 11, autohs
  edit "", 4, 42 28 100 11, autohs
  edit "", 9, 42 44 30 11, autohs
  text "", 7, 10 14 30 11
  text "", 8, 10 30 30 11
  text "", 10, 10 46 30 11
  text "", 12, 77 46 60 11
}

on *:dialog:join.edit:init:*: {
  mdx_mark
  mdx_call SetFont $dname 2 +a 15 900 verdana
  mdxfonts $dname 1,11,2,3,4,7,8,9,10,12
  mdx_call SetDialog $dname icon 1 $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
  ;mdx_call SetBorderStyle $dname 3,4,9 staticedge
  mdx_setcontrol $dname 9 updown wrap ctl_gen edit center numeric alignright hscroll
  did -i $dname 9 1 0 0 9999
  set %join.chan $gettok($read($auto_txt,%join.edit),1,149)
  set %join.net $gettok($read($auto_txt,%join.edit),2,149)
  set %join.delay $gettok($read($auto_txt,%join.edit),3,149)
  did -a $dname 1 $_lang(join.edit,1) | did -a $dname 11 $_lang(join.edit,11) | did -a $dname 12 $_lang(join.edit,12)
  did -a $dname 2 $_lang(join.edit,2) | did -a $dname 7 $_lang(join.edit,7) | did -a $dname 8 $_lang(join.edit,8)
  did -a $dname 10 $_lang(join.edit,10)
  did -a $dname 2 Edit info for %join.chan | did -a $dname 3 %join.chan | did -a $dname 4 %join.net | did -i $dname 9 1 %join.delay
}
on *:dialog:join.edit:edit:*: { set %join.chan $did(3).text | set %join.net $did(4).text | set %join.delay $gettok($did($dname,9,1),1,32) }
on *:dialog:join.edit:close:*: { join.unset }
on *:dialog:join.edit:sclick:1: {
  if (%join.chan == $null) || (%join.net == $null) { 
    dll $_hdll Error Error Message > You left a field empty. | halt 
  }
  elseif (*#* !iswm %join.chan) { 
    dll $_hdll Error Error Message > Channel name must have '#' | halt 
  }
  elseif (*#* iswm %join.net) || (*;* iswm %join.net) || (*$* iswm %join.net) || (*^* iswm %join.net) || (*&* iswm %join.net) { 
    dll $_hdll Error Error Message > Can't add simbols in Network name. $chr(40) $+ %join.net $+ $chr(41) | halt 
  }
  else { 
    write -l %join.edit $auto_txt %join.chan $+ $chr(149) $+ %join.net $+ $chr(149) $+ %join.delay
    join.unset
  }
  auto_load
}
on *:dialog:ident.edit:edit:*: { set %addnick.2 $did(3).text | set %addnet.2 $did(4).text | set %addcom.2 $did(5).text | set %addpass.2 $did(6).text }

;
; MODULE MANAGER
;
dialog module {
  title ""
  size -1 -1 230 174
  option dbu
  list 1, 1 1 228 158, size
  button "", 2, 192 161 37 12
  button "", 3, 154 161 37 12, default ok
  button "", 100, 0 0 0 0
}
on *:dialog:module:init:*: {
  mdx_mark
  mdxfonts $dname 1,2,3 | mdxbuttons 2,3
  mdx_setcontrol $dname 100 positioner dialog minbox maxbox size
  _lang.module
  mdx_call SetDialog $dname icon 2 $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
  ; mdx_call SetBorderStyle $dname 1 staticedge
  mdx_setcontrol $dname 1 ListView views headerdrag report rowselect showsel nosortheader single grid checkboxes
  did -i $dname 1 1 headerdims 210 100 70 500
  did -i $dname 1 1 headertext $_lang($dname,19) $chr(9) $_lang($dname,20) $chr(9) $_lang($dname,21) $chr(9) $_lang($dname,22)
  _loadaddons addons\ | _loadaddons system\scripts\modules
}

on *:dialog:module:sclick:2: { hlp module }
on *:dialog:module:sclick:3: { 
  var %x = 1
  while (%x < $did(1).lines) {
    inc %x
    tokenize 32 $did(1,%x)
    var %file = $gettok($1-,2-,4)
    if ($5 != 2) { pbar 10 Unloading... | .unload -rs %file | pbar 100 Complete. }
    if ($5 == 2) && ($script( [ %file ] ) == $null) { pbar 10 Loading... | .load -rs %file | pbar 100 Complete. }
  }
  _cpanel
}
on *:dialog:module:sclick:100: {
  if ($gettok($did(100,1),1,32) != size) { halt }
  did -i $dname 1 1 headerdims 210 100 70 $calc($dialog($dname).w - 5)
  mdx_call MoveControl $dname 1 * * $calc($dialog($dname).w - 12) $calc($dialog($dname).h - 66)
  mdx_call MoveControl $dname 2 $calc($dialog($dname).w - 84) $calc($dialog($dname).h - 61) * *
  mdx_call MoveControl $dname 3 $calc($dialog($dname).w - 158) $calc($dialog($dname).h - 61) * *
}
;
;   SETUP
;
dialog G.Settings {
  title "General Configuration [ /Setup ]"
  size -1 -1 246 174
  option dbu
  button "&Ok", 1, 128 160 37 12, default ok
  button "&Cancel", 3, 166 160 37 12, cancel
  button "&Help", 999, 204 160 37 12
  button "", 2000, 0 0 0 0
  list 2, 1 1 69 149, size
  text "_________________________________________________________________________________", 1000, 2 150 243 7, disable
  tab "general", 900, 61 321 99 22
  BOX "Others" 433, 159 20 82 53 ,  tab 900
  check "&Auto Voice mp3 servers" 441, 165 30 72 10, tab 900
  check "&Voice Thanker" 455, 165 40 55 10, tab 900
  Check "O&p Thanker" 454, 165 50 58 10, tab 900
  check "&Nick Say", 427, 165 60 32 10, tab 900
  check "&Beep", 428, 205 60 28 10, tab 900
  BOX "On Start" 434, 75 20 80 53,  tab 900
  check "&Control Panel" 435, 80 30 60 10, tab 900
  check "&Tips" 436, 80 40 60 10, tab 900
  check "&Servers List" 442, 80 50 60 10, tab 900
  check "A&bout" 444, 80 60 60 10, tab 900

  BOX "On Connect" 447, 75 76 80 31,  tab 900
  check "&Auto Update hIRC" 443, 80 89 60 10, tab 900

  BOX "Ping" 437, 75 109 80 20,  tab 900
  check "&Enable ping reply" 438, 80 116 71 10, tab 900
  box "Dcc", 419, 159 76 82 53, tab 900
  check "&Reject these files", 420, 165 84 64 11, tab 900
  edit "", 421, 165 95 69 10, tab 900 autohs
  check "Auto accept protected nicks", 422, 165 107 73 12, tab 900

  tab "Display", 910, 61 321 99 22
  check "&Show clones on join", 424, 80 24 100 10, tab 910
  check "&Whois on query", 425, 80 34 100 10, tab 910
  check "Query buttons", 445, 80 44 100 10, tab 910
  check "Use .NET Colors", 446, 88 54 100 10, tab 910

  check "Too&lbar", 426, 80 64 102 10, tab 910
  check "La&g Bar", 429, 88 74 102 10, tab 910
  check "Use .NET Colors", 439, 88 84 102 10, tab 910
  check "S&witchbar", 430, 80 94 102 10, disable tab 910
  check "Use .NET Colors", 440, 88 104 102 10, disable tab 910
  ;check "Stat&usbar", 431, 80 114 102 10, tab 910
  text "Change icon theme", 450, 80 116 65 10, tab 910
  combo 451, 155 114 60 310, size tab 910

  tab "Dialogs style", 610
  check "&Italic", 611, 188 36 45 12, tab 610 
  check "&Bold", 612, 188 48 45 12, tab 610 
  check "&Underlined", 613, 188 60 44 12, tab 610 
  check "&Strikeout", 617, 188 72 40 12, tab 610 
  button "&Restore", 631, 90 160 37 12, tab 610

  box "Font style", 614, 184 25 55 86, tab 610 
  box "Font", 615, 75 25 106 100, tab 610 
  button "&Preview", 616, 184 113 56 12, tab 610

  list 618, 80 45 96 60, tab 610 size 
  text "Size", 619, 80 110 63 11, tab 610 
  combo 620, 126 108 50 95, tab 610 size drop 
  edit "", 621, 80 35 96 10, tab 610 size

  tab "buttons", 640
  radio "Staticedge", 641, 140 30 37 15, tab 640 push
  radio "Clientedge", 642, 140 48 37 15, tab 640 push
  radio "Dlgmodal", 643, 140 66 37 15, tab 640 push
  radio "Plain button", 644, 140 84 37 15, tab 640 push
  radio "Border", 645, 140 102 37 15, tab 640 push
  box "Buttons", 646, 130 20 55 103, tab 640
  button "Preview", 647, 130 125 56 12, tab 640

  tab "Titlebar", 623
  text "Style", 624, 80 30 24 12, tab 623
  edit "titlebar", 625, 80 43 158 12, tab 623 autohs
  text "Preview", 626, 80 60 39 12, tab 623
  icon 627, 80 71 158 16, $mircdirsystem\img\temp.bmp, tab 623
  text "Codes:", 629, 80 90 34 12, tab 623
  text "<version>, <me>, <server>, <usermode>, <lag>, <idle>, <sessions>, <network>, <active>", 630, 80 97 158 25, disable tab 623

  ;autoident
  tab "autoident", 4, 61 121 99 22
  list 31, 80 26 157 92, size tab 4
  check "&Enable", 35, 80 122 30 10, tab 4
  check "Hide &Password", 37, 80 132 59 10, tab 4

  ;auto join
  tab "auto join", 700
  list 701, 80 26 157 92, size tab 700 
  check "&Enable", 705, 80 122 49 10, tab 700
  check "Minimize channel on join", 708, 80 132 149 10, tab 700

  ;popups
  tab "status", 902, 61 321 99 22
  text "Select which items to show within the status popups", 781, 80 25 165 10, tab 902
  check "&Connect", 950, 105 35 50 10, tab 902
  check "&Feedback", 951, 105 45 50 10, tab 902
  check "&Update", 952, 105 55 50 10, tab 902
  check "&Documents", 953, 105 65 50 10, tab 902
  check "&About", 954, 105 75 50 10, tab 902
  check "&Window", 955, 105 85 50 10, tab 902

  tab "channel", 903, 61 321 99 22
  text "&Select which items to show within the channel popups", 782, 80 25 165 10, tab 903
  check "&Channel", 960, 105 35 50 10, tab 903
  check "&Setup", 964, 105 45 50 10, tab 903
  check "&Network Commands", 961, 105 55 80 10, tab 903
  check "&Join", 962, 105 65 50 10, tab 903
  check "&Part", 963, 105 75 50 10, tab 903
  check "&Away", 965, 105 85 50 10, tab 903
  check "&Misc", 966, 105 95 50 10, tab 903
  check "&Utilities", 967, 105 105 50 10, tab 903
  check "&AntiSpam", 968, 105 115 50 10, tab 903
  check "&Window", 969, 105 125 50 10, tab 903

  tab "chat", 904, 61 321 99 22
  text "Select which items to show within the query\chat popups", 783, 80 25 165 10, tab 904
  check "&User Info", 970, 105 35 50 10, tab 904
  check "&CTCP", 971, 105 45 60 10, tab 904
  check "&DCC", 972, 105 55 50 10, tab 904
  check "&Ignore", 973, 105 65 50 10, tab 904
  check "&Notify", 974, 105 75 50 10, tab 904
  check "&Protect", 975, 105 85 50 10, tab 904
  check "&Other", 976, 105 95 50 10, tab 904
  check "&Misc", 977, 105 105 50 10, tab 904
  check "&Window", 978, 105 115 50 10, tab 904

  tab "nick", 905, 61 321 99 22
  text "Select which items to show within the nicklist popups", 784, 80 25 165 10, tab 905
  check "&Network Commands", 980, 105 35 60 10, tab 905
  check "&User Info", 981, 105 45 60 10, tab 905
  check "&CTCP", 982, 105 55 50 10, tab 905
  check "&DCC", 983, 105 65 50 10, tab 905
  check "&Ignore", 984, 105 75 50 10, tab 905
  check "&Notify", 985, 105 85 50 10, tab 905
  check "&Protect", 986, 105 95 50 10, tab 905
  check "&Other", 987, 105 105 50 10, tab 905

  tab "sounds" 906, 8 300 50 12
  list 990, 80 26 157 114, tab 906 size

  tab "Cursor", 810
  box "Cursors", 811, 75 25 55 100, tab 810 
  box "Preview", 812, 135 25 106 100, tab 810 
  list 813, 80 33 45 88, disable tab 810 size 
  check "Enable", 815, 80 130 60 14, tab 810
  list 814, 139 33 98 88, size disable hide tab 810
  list 816, 139 33 98 88, size disable hide tab 810
  list 817, 139 33 98 88, size disable hide tab 810
  list 818, 139 33 98 88, size disable hide tab 810
  list 819, 139 33 98 88, size disable hide tab 810

  list 2001, 71 1 174 14, disable hide size
  list 2002, 71 1 174 14, disable hide size
  list 2003, 71 1 174 14, disable hide size
  list 2004, 71 1 174 14, disable hide size
  list 2005, 71 1 174 14, disable hide size
  list 2006, 71 1 174 14, disable hide size
  list 2007, 71 1 174 14, disable hide size
  list 2008, 71 1 174 14, disable hide size
  list 2009, 71 1 174 14, disable hide size
  list 2010, 71 1 174 14, disable hide size
}
on *:dialog:g.settings:edit:*:{ 
  $iif($did(625),did -g $dname 627 $tbar.preview($did(625))) 
  if ($did == 621) && ($didwm($dname,618,$+(*,$did(621),*))) { did -c $dname 618 $ifmatch } 
}
on *:DIALOG:G.Settings:init:*:{
  mdx_mark
  mdx_setcontrol $dname 2 TreeView views haslines fullrowselect hasbuttons
  mdx_call SetFont $dname 624,626,629 +a 15 900 verdana
  mdx_call SetDialog $dname icon 38 $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
  mdx_setcontrol $dname 451 ComboBoxex views simple drop
  mdxfonts $dname 1,999,2,3,433,441,419,420,421,422,423,424,425,426,429,430,427,428,434,435,436,437,438,439,440,442,443,444,445,446,447,450,451,455,454
  mdxfonts $dname 611,612,613,616,617,614,615,618,619,620,625,631,646,647,31,35,37,701,705,708,781,811,812,813,815,950,951,
  mdxfonts $dname 952,953,954,955,782,960,964,961,962,963,965,966,967,968,969,783,970,971,972,973,974,975,976,977,978,784,980,
  mdxfonts $dname 981,982,983,984,985,986,987,990,
  mdxbuttons 1,3,616,631,647,999,998
  ;titlebar
  mdx_setcontrol $dname 2001,2002,2003,2004,2005,2006,2007,2008,2009,2010 Toolbar bars flat wrap nodivider list noresize
  mdx_call SetFont $dname 2001,2002,2003,2004,2005,2006,2007,2008,2009,2010 -15 700 Tahoma
  mdx_call SetBorderStyle 2001,2002,2003,2004,2005,2006,2007,2008,2009,2010
  mdx_call SetColor $dname 2001,2002,2003,2004,2005,2006,2007,2008,2009,2010 background $rgb(135,141,141)
  did -i $dname 2001,2002,2003,2004,2005,2006,2007,2008,2009,2010 1 bmpsize 16 16
  did -i $dname 2001,2002,2003,2004,2005,2006,2007,2008,2009,2010 1 bwidth 200 200
  did -i $dname 2001,2002,2003,2004,2005,2006,2007,2008,2009,2010 1 settxt color $hget(255,255,255)
  did -v $dname 2001 | did -h $dname 2002,2003,2004,2005,2006,2007,2008,2009,2010
  did -i $dname 2001 1 setimage icon small 38, $+ $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
  did -a $dname 2001 1 $chr(160) General Setup
  sethelp 2000
  ; mdx_call SetBorderStyle $dname 2,618,31,421,625,701,990,813,814,816,817,818,819 staticedge
  ;buttons
  mdx_call SetBorderStyle $dname 641 staticedge
  mdx_call SetBorderStyle $dname 642 clientedge
  mdx_call SetBorderStyle $dname 643 dlgmodal
  mdx_call SetBorderStyle $dname 645 border
  if ($Bsetting(Buttons,style) == staticedge) { did -c $dname 641 }
  if ($Bsetting(Buttons,style) == clientedge) { did -c $dname 642 }
  if ($Bsetting(Buttons,style) == dlgmodal) { did -c $dname 643 }
  if ($Bsetting(Buttons,style) == mirc) { did -c $dname 644 }
  if ($Bsetting(Buttons,style) == border) { did -c $dname 645 }
  setup.lang
  add +eb Settings
  comdx cb last
  add +e General
  add +e Auto Join
  add +e Auto Identify
  add +e Display

  add +eb Editors
  comdx cb last
  add +e Cursors
  add +e Dialog Fonts
  add +e Dialog Buttons
  add +e Titlebar
  add +b PopUps
  comdx cb last
  addtok 32 Status Channel Query\Chat NickList
  comdx cb up
  comdx cb up
  add +eb Sound Events
  ;add +eb Version Reply
  mdx_setcontrol $dname 31,990 ListView views headerdrag report rowselect showsel nosortheader single checkboxes
  did -i $dname 990 1 headerdims 100 192
  did -i $dname 990 1 headertext $_lang(setup,990a) $tab $+ +c $_lang(setup,990b)
  var %i = 1
  while ($ini($sounds_ini,%i)) {
    did -a $dname 990 0 0 0 $iif($readini($sounds_ini,$ifmatch,status) == on,2,1) $ini($sounds_ini,%i) $chr(9) $nopath($readini($sounds_ini,$ini($sounds_ini,%i),sound))
    inc %i
  }
  mdx_setcontrol $dname 701 ListView views headerdrag report rowselect icon showsel nosortheader single
  did -i $dname 701 1 headerdims 150 100 60
  did -i $dname 701 1 seticon normal 0 69, $+ $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
  did -i $dname 701 1 headertext $tab($_lang(setup,aj1),$_lang(setup,aj2),$_lang(setup,aj3))
  $iif($hget(setup,a^join) == 1,did -c $dname 705)
  $iif($hget(setup,a^join.min) == 1,did -c $dname 708)
  auto_load

  did -ra $dname 421 $hget(setup,files)
  $iif($hget(setup,reject) == on,did -c $dname 420)
  $iif($hget(setup,accept) == on,did -c $dname 422)
  $iif($hget(setup,clones) == on,did -c $dname 424)
  $iif($hget(setup,whois) == on,did -c $dname 425)
  $iif($Bsetting(toolbar,lag) == on,did -c $dname 429)
  if ($hget(setup,toolbar) == 1) { 
    did -c $dname 426
    did -e $dname 429
    did -e $dname 439
  }
  if ($hget(setup,toolbar) == 0) { did -b $dname 429 }
  if ($dialog(sb)) { did -c $dname 430 | did -e $dname 440 }
  else { did -b $dname 440 }
  if ($hget(setup,tool.net) == 1) { did -c $dname 439) } 
  if ($hget(setup,switch.net) == 1) { did -c $dname 440) } 
  ; if ($bsetting(statusbar,on) == true) { did -c $dname 431 }
  $iif($hget(setup,voicemp3) == 1,did -c $dname 441)
  $iif($hget(setup,server.startup) == 1,did -c $dname 442)
  $iif($hget(setup,hIRC.Update) == 1,did -c $dname 443)
  $iif($hget(setup,about) == 1,did -c $dname 444)
  if ($hget(setup,query.buttons) == 1) {
    did -c $dname 445
    did -e $dname 446
  }
  else { did -b $dname 446 }
  $iif($hget(setup,query.net) == 1,did -c $dname 446)

  $iif($hget(setup,Opthank) == 1,did -c $dname 454)
  $iif($hget(setup,vthank) == 1,did -c $dname 455)

  ;icon selection
  did -i $dname 451 1 iconsize small
  var %a = 1
  while (%a <= $findfile(system\img\,*?.icl,0)) {
    var %file = $findfile(system\img\,*?.icl,%a)
    did -i $dname 451 1 seticon 0 0, $+ %file
    did -a $dname 451 %a %a %a 0 $left($nopath(%file),-4)
    if ($hget(setup,icon.theme) == $left($nopath(%file),-4)) var %451.sel = $calc(%a + 1)
    inc %a
  }
  did -c $dname 451 %451.sel

  if ($bsetting(other,mention) == on) {
    did -c $dname 427
    did -e $dname 428
  }
  $iif($bsetting(other,bmention) == on,did -c $dname 428)
  if ($bsetting(other,mention) == off) { did -b $dname 428 }
  $iif($bsetting(other,ping) == on,did -c $dname 438)

  $iif($hget(cpanel,cpanel) == 1,did -c $dname 435)
  $iif($hget(setup,tips) == 1,did -c $dname 436)

  $iif($Bsetting(sconnect,s) == on,did -c $dname 950) | $iif($Bsetting(sfeedback,s) == on,did -c $dname 951) | $iif($Bsetting(supdate,s) == on,did -c $dname 952) | $iif($Bsetting(sdocuments,s) == on,did -c $dname 953) | $iif($Bsetting(sabout,s) == on,did -c $dname 954)
  $iif($Bsetting(swindow,s) == on,did -c $dname 955)
  $iif($Bsetting(cchannel,s) == on,did -c $dname 960)
  $iif($Bsetting(cnetwork,s) == on,did -c $dname 961)
  $iif($Bsetting(cjoin,s) == on,did -c $dname 962)
  $iif($Bsetting(cpart,s) == on,did -c $dname 963)
  $iif($Bsetting(csetup,s) == on,did -c $dname 964)
  $iif($Bsetting(caway,s) == on,did -c $dname 965)
  $iif($Bsetting(cmisc,s) == on,did -c $dname 966)
  $iif($Bsetting(cUtilities,s) == on,did -c $dname 967)
  $iif($Bsetting(cAntiSpam,s) == on,did -c $dname 968)
  $iif($Bsetting(cwindow,s) == on,did -c $dname 969)

  $iif($Bsetting(quser,s) == on,did -c $dname 970)
  $iif($Bsetting(qctcp,s) == on,did -c $dname 971)
  $iif($Bsetting(qdcc,s) == on,did -c $dname 972)
  $iif($Bsetting(qignore,s) == on,did -c $dname 973)
  $iif($Bsetting(qnotify,s) == on,did -c $dname 974)
  $iif($Bsetting(qprotect,s) == on,did -c $dname 975)
  $iif($Bsetting(qother,s) == on,did -c $dname 976)
  $iif($Bsetting(qmisc,s) == on,did -c $dname 977)
  $iif($Bsetting(qwindow,s) == on,did -c $dname 978)

  $iif($Bsetting(nnetwork,s) == on,did -c $dname 980)
  $iif($Bsetting(nuser,s) == on,did -c $dname 981)
  $iif($Bsetting(nctcp,s) == on,did -c $dname 982)
  $iif($Bsetting(ndcc,s) == on,did -c $dname 983)
  $iif($Bsetting(nignore,s) == on,did -c $dname 984)
  $iif($Bsetting(nnotify,s) == on,did -c $dname 985)
  $iif($Bsetting(nprotect,s) == on,did -c $dname 986)
  $iif($Bsetting(nother,s) == on,did -c $dname 987)

  did -i $dname 31 1 headerdims 100 90 100 130
  did -i $dname 31 1 headertext $_lang(setup,31a) $chr(9) $_lang(setup,31b) $chr(9) $_lang(setup,31c) $chr(9) $_lang(setup,31d) 
  autoident.load
  if ($hget(autoident,enable) == 1) { did -c $dname 35 }
  if ($hget(autoident,hide) == 1) { did -c $dname 37 }

  ;cursors
  did -a $dname 813 Blue
  did -a $dname 813 Green
  did -a $dname 813 Black
  did -a $dname 813 Grey
  did -a $dname 813 Yellow
  mdx_setcontrol $dname 814,816,817,818,819 ListView views autoarange icon
  did -i $dname 814 1 seticon list cursors\Blue.cur
  did -a $dname 814 1 1 $nopath(cursors\Blue.cur)
  did -i $dname 816 1 seticon list cursors\Green.cur
  did -a $dname 816 1 1 $nopath(cursors\Green.cur)
  did -i $dname 817 1 seticon list cursors\Black.cur
  did -a $dname 817 1 1 $nopath(cursors\Black.cur)
  did -i $dname 818 1 seticon list cursors\Grey.cur
  did -a $dname 818 1 1 $nopath(cursors\Grey.cur)
  did -i $dname 819 1 seticon list cursors\Yellow.cur
  did -a $dname 819 1 1 $nopath(cursors\Yellow.cur)
  if ($hget(setup,enable.cursor) == 1) {
    did -c $dname 815
    did -e $dname 813,814,816,817,818,819
  }
  hadd setup temp.cursor $hget(setup,enable.cursor)
  else { did -b $dname 813,814,816,817,818,819 }
  if (blue isin $bsetting(cursor,1)) { did -v $dname 814 | did -h $dname 816,817,818,819 | did -c $dname 813 1 }
  if (green isin $bsetting(cursor,1)) { did -v $dname 816 | did -h $dname 814,817,818,819 | did -c $dname 813 2 }
  if (black isin $bsetting(cursor,1)) { did -v $dname 817 | did -h $dname 816,814,818,819 | did -c $dname 813 3 }
  if (grey isin $bsetting(cursor,1)) { did -v $dname 818 | did -h $dname 816,817,814,819 | did -c $dname 813 4 }
  if (yellow isin $bsetting(cursor,1)) { did -v $dname 819 | did -h $dname 816,817,818,814 | did -c $dname 813 5 }

  ;misc
  $iif($hget(setup,bold) == on,did -c $dname 612)
  $iif(s isin $hget(setup,style),did -c $dname 617)
  $iif(u isin $hget(setup,style),did -c $dname 613)
  $iif(i isin $hget(setup,style),did -c $dname 611)

  mdx_call SetFont $dname 611 +i $calc($hget(setup,size) + 5) 5 $hget(setup,font)
  mdx_call SetFont $dname 612 $calc($hget(setup,size) + 5) 5 $hget(setup,font)
  mdx_call SetFont $dname 613 +u $calc($hget(setup,size) + 5) 5 $hget(setup,font)
  mdx_call SetFont $dname 617 +s $calc($hget(setup,size) + 5) 5 $hget(setup,font)

  ;fonts
  didtok $dname 618 44 Arial,Arial Black,Arial Narrow,Book Antiqua,Bookman Old Style,Century Gothic,Comic Sans MS,Courier New,Estrangelo Edessa,Franklin Gothic Medium,Garamond,Gautami,Georgia,Impact,IBMpc,Latha,Lucida Console,Lucida Sans Unicode,Mangal,Marlett,Microsoft Sans Serif,Monotype Corsiva,MV Boli,Palatino Linotype,Raavi,Shruti,Sylfaen,Symbol,Tahoma,Times New Roman,Trebuchet MS,Tunga,Verdana,Webdings,Wingdings
  %i = 1
  while (%i <= 37) {
    $iif($did(618,%i).text == $hget(setup,font),did -c $dname 618 %i)
    inc %i
  }
  did -ra $dname 621 $hget(setup,font)
  ;font size
  didtok $dname 620 44 5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28
  var %i = 1
  while (%i <= 24) {
    $iif($did(620,%i).text == $hget(setup,size),did -c $dname 620 %i)
    inc %i
  }
  did -g $dname 627 $tbar.preview($remove($hget(setup,titlebar.style),hIRC $bersion))
  did -ra $dname 625 $remove($hget(setup,titlebar.style),hIRC $bersion)
  ;colors
  did -i $dname 31,701,990 1 setbkg color $hget(rgb,bg)
  did -i $dname 31,701,990 1 settxt color $hget(rgb,txt)
  did -i $dname 31,701,990 1 settxt bgcolor $hget(rgb,txtbg)
  did -i $dname 2 1 setcolor text $hget(rgb,txt)
  did -i $dname 2 1 setcolor bkg $hget(rgb,bg)
  did -i $dname 2 1 setcolor line $hget(rgb,lines)
}
on *:DIALOG:G.Settings:sclick:*:{
  if ($did == 1) {
    $iif($dialog(_dfont),dialog -x _dfont)
    pbar 10 Saving Settings...
    ident.unset
    unset %tmp*
    update.snd.list
    hadd setup accept $iif($did(422).state == 1,on,off)
    hadd setup whois $iif($did(425).state == 1,on,off)  
    hadd setup clones $iif($did(424).state == 1,on,off)
    hadd setup reject $iif($did(420).state == 1,on,off)
    if ($did(426).state == 1) { hadd setup toolbar 1 | $iif(!$dialog(tbar),_dialog tbar) }
    elseif ($did(426).state == 0) { hadd setup toolbar 0 | $iif($dialog(tbar),dialog -c tbar) }
    pbar 50 Saving Settings...
    ;dialog
    hadd setup font $did(618,$did(618).sel).text
    hadd setup size $did(620,$did(620).sel).text
    hadd setup style $+(+,$iif($did(611).state == 1,i),$iif($did(613).state == 1,u),$iif($did(617).state == 1,s))
    hadd setup server.startup $did(442).state
    hadd setup hIRC.Update $did(443).state
    hadd setup about $did(444).state
    hadd setup query.net $did(446).state

    $iif($did(612).state == 1,hadd setup bold on,hadd setup bold off)

    ;buttons
    if ($did(641).state == 1) { Tsetting Buttons style staticedge }
    if ($did(642).state == 1) { Tsetting Buttons style clientedge }
    if ($did(643).state == 1) { Tsetting Buttons style dlgmodal }
    if ($did(644).state == 1) { Tsetting Buttons style mirc }
    if ($did(645).state == 1) { Tsetting Buttons style border }
    ;cursor
    if ($hget(setup,enable.cursor) == 1) {
      if ($did($dname,813).seltext == Blue) { Tsetting cursor 1 $+(",$mircdircursors\Blue.cur,") | dll $cursor SetMouseCursor cursors\Blue.cur }
      if ($did($dname,813).seltext == Green) { Tsetting cursor 1 $+(",$mircdircursors\Green.cur,") | dll $cursor SetMouseCursor cursors\Green.cur }
      if ($did($dname,813).seltext == Black) { Tsetting cursor 1 $+(",$mircdircursors\Black.cur,") | dll $cursor SetMouseCursor cursors\Black.cur } 
      if ($did($dname,813).seltext == Grey) { Tsetting cursor 1 $+(",$mircdircursors\Grey.cur,") | dll $cursor SetMouseCursor cursors\Grey.cur }
      if ($did($dname,813).seltext == Yellow) { Tsetting cursor 1 $+(",$mircdircursors\Yellow.cur,") | dll $cursor SetMouseCursor cursors\Yellow.cur } 
    }
    ;auto identify
    aident.update
    ident.unset

    ;icon selection
    if (%icon.theme == $null) { set %icon.theme $gettok($did($dname,451),5-,32) }
    if (%icon.theme != $hget(setup,icon.theme)) {
      hadd setup icon.theme %icon.theme | treset | _panel.write | nlistdock.pos
      if ($dialog(tbar)) { toolbar | toolbar }
      if ($dialog(panel)) { dialog -x panel | cpanel }
    }
    .unset %icon.theme

    if ($did(429).state == 1) { 
      toolbar
      toolbar | if ($dialog(tbar) != $null) { did -v tbar 3,5,6 | did -h tbar 7 }
    }
    elseif ($did(429).state == 0) { 
      toolbar
      toolbar | if ($dialog(tbar) != $null) { did -h tbar 3,5,6 | did -v tbar 7 }
    }
    hadd setup files $$did(421)
    if ($did(430).state == 1) { if (!$dialog(sb)) { switchbar } }
    if ($did(430).state == 0) { if ($dialog(sb)) { switchbar } }
    if ($did(440).state == 1) && ($did(430).state == 1) { if ($dialog(sb)) { switchbar | switchbar } }
    if ($did(440).state == 0) && ($did(430).state == 1) { if ($dialog(sb)) { switchbar | switchbar } }

    ;if ($did(431).state == 1) { 
    ;  if ($bsetting(statusbar,on) == false) { Tsetting statusbar on true | create.sb }
    ;}
    ;if ($did(431).state == 0) {
    ;  if ($bsetting(statusbar,on) == true) { Tsetting statusbar on false | create.sb | create.sb }
    ;}
    ;misc
    if ($did(625)) hadd setup titlebar.style $hget(setup,script) $bersion $remove($did(625),hIRC $bersion)
    hadd setup font $did(618,$did(618).sel).text
    hadd setup size $did(620,$did(620).sel).text
    hadd setup style $+(+,$iif($did(611).state == 1,i),$iif($did(613).state == 1,u),$iif($did(617).state == 1,s))
    $iif($did(612).state == 1,hadd setup bold on,hadd setup bold off)
    _cpanel
    pbar 100 Complete
    unset %pbar*
    if ($hget(setup,enable.cursor) != $hget(setup,temp.cursor)) { if ($?!=" $_lang(setup,815a) " == $true) { /_restart } }
    hdel setup temp.cursor
    if ($dialog(notify)) { _reopen.notif | _nlist }
  }
  if ($did == 631) { restore.dialog }

  ;listview
  if ($did == 2) {
    var %clicked = $gettok($did(2,1),4-,32)
    if (%clicked == 2 2) { 
      did -f $dname 900 
      did -v $dname 2001 | did -h $dname 2002,2003,2004,2005,2006,2007,2008,2009,2010
      did -i $dname 2001 1 setimage +nh icon small 38, $+ $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
      did -a $dname 2001 1 $chr(160) $_lang(setup,2001)
    }
    if (%clicked == 2 3) { 
      did -f $dname 700 
      did -v $dname 2002 | did -h $dname 2001,2003,2004,2005,2006,2007,2008,2009,2010
      did -i $dname 2002 1 setimage icon small 1, $+ $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
      did -a $dname 2002 1 $chr(160) $_lang(setup,706) 
    }
    if (%clicked == 2 4) { 
      did -f $dname 4 
      did -v $dname 2003 | did -h $dname 2001,2002,2004,2005,2006,2007,2008,2009,2010
      did -i $dname 2003 1 setimage icon small 32, $+ $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
      did -a $dname 2003 1 $chr(160) $_lang(setup,36)
    }
    if (%clicked == 2 5) { 
      did -f $dname 910 
      did -v $dname 2004 | did -h $dname 2001,2002,2003,2005,2006,2007,2008,2009,2010
      did -i $dname 2004 1 setimage icon small 14, $+ $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
      did -a $dname 2004 1 $chr(160) $_lang(setup,2004)
    }
    if (%clicked == 2 6 2) { 
      did -f $dname 810 
      did -v $dname 2005 | did -h $dname 2001,2002,2003,2004,2006,2007,2008,2009,2010
      did -i $dname 2005 1 setimage icon small cursors\Blue.cur
      did -a $dname 2005 1 $chr(160) $_lang(setup,2005)
    }
    if (%clicked == 2 6 3) { 
      did -f $dname 610 
      did -v $dname 2006 | did -h $dname 2001,2002,2003,2004,2005,2007,2008,2009,2010
      did -i $dname 2006 1 setimage icon small 22, $+ $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
      did -a $dname 2006 1 $chr(160) $_lang(setup,2006)
    }
    if (%clicked == 2 6 4) { 
      did -f $dname 640 
      did -v $dname 2007 | did -h $dname 2001,2002,2003,2004,2005,2006,2008,2009,2010
      did -i $dname 2007 1 setimage icon small 33, $+ $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
      did -a $dname 2007 1 $chr(160) $_lang(setup,2007)
    }
    if (%clicked == 2 6 5) { 
      did -f $dname 623 
      did -v $dname 2008 | did -h $dname 2001,2002,2003,2004,2005,2006,2007,2009,2010
      did -i $dname 2008 1 setimage icon small 15, $+ $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
      did -a $dname 2008 1 $chr(160) $_lang(setup,2008)
    }
    if (%clicked == 2 6 6 2) { 
      did -f $dname 902 
      did -v $dname 2009 | did -h $dname 2001,2002,2003,2004,2005,2006,2007,2010
      did -i $dname 2009 1 setimage icon small 19, $+ $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
      did -a $dname 2009 1 $chr(160) $_lang(setup,2009)
    }
    if (%clicked == 2 6 6 3) { 
      did -f $dname 903 
      did -v $dname 2009 | did -h $dname 2001,2002,2003,2004,2005,2006,2007,2010
      did -i $dname 2009 1 setimage icon small 19, $+ $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
      did -a $dname 2009 1 $chr(160) $_lang(setup,2009)
    }
    if (%clicked == 2 6 6 4) { 
      did -f $dname 904 
      did -v $dname 2009 | did -h $dname 2001,2002,2003,2004,2005,2006,2007,2010
      did -i $dname 2009 1 setimage icon small 19, $+ $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
      did -a $dname 2009 1 $chr(160) $_lang(setup,2009)
    }
    if (%clicked == 2 6 6 5) { 
      did -f $dname 905 
      did -v $dname 2009 | did -h $dname 2001,2002,2003,2004,2005,2006,2007,2010
      did -i $dname 2009 1 setimage icon small 19, $+ $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
      did -a $dname 2009 1 $chr(160) $_lang(setup,2009)
    }
    if (%clicked == 2 7) { 
      did -f $dname 906 
      did -v $dname 2010 | did -h $dname 2001,2002,2003,2004,2005,2006,2007,2009
      did -i $dname 2010 1 setimage icon small 25, $+ $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
      did -a $dname 2010 1 $chr(160) $_lang(setup,991) 
    }
    ; if (%clicked == 2 9) { did -f $dname 800 }
  }
  if ($did == 435) { $iif($hget(cpanel,cpanel) == 1,hadd cpanel cpanel 0,hadd cpanel cpanel 1) }
  if ($did == 436) { $iif($hget(setup,tips) == 1,hadd setup tips 0,hadd setup tips 1) }
  if ($did == 429) { $iif($Bsetting(toolbar,lag) == on,Tsetting toolbar lag off,Tsetting toolbar lag on) }

  if ($did == 426) {
    $iif($hget(setup,toolbar) == 1,hadd setup toolbar 0,hadd setup toolbar 0)
    if ($hget(setup,toolbar) == 1) { 
      did -e $dname 429
      did -e $dname 439
    }
    if ($hget(setup,toolbar) == 0) { 
      did -b $dname 429
      did -b $dname 439
    }
  }
  if ($did == 427) { 
    $iif($Bsetting(other,mention) == on,Tsetting other mention off,Tsetting other mention on) 
    if ($Bsetting(other,mention) == off) { did -b $dname 428 }
    if ($Bsetting(other,mention) == on) { did -e $dname 428 }
  }
  if ($did == 428) { $iif($Bsetting(other,bmention) == on,Tsetting other bmention off,Tsetting other bmention on) }
  if ($did == 441) { $iif($hget(setup,voicemp3) == 1,hadd setup voicemp3 0,hadd setup voicemp3 1) 
    if ($hget(setup,voicemp3) == 1) { vauto }
    if ($cfg(other,voicemp3) == off) { vauto }
  }
  if ($did == 430) { 
    $iif($Bsetting(switchbar,s) == on,Tsetting switchbar s off,Tsetting switchbar s on) 
    if ($Bsetting(switchbar,s) == off) { did -b $dname 440 }
    if ($Bsetting(switchbar,s) == on) { did -e $dname 440 }
  }
  if ($did == 439) { $iif($hget(setup,tool.net) == 1,hadd setup tool.net 0,hadd setup tool.net 1) }
  if ($did == 440) { $iif($hget(setup,switch.net) == 1,hadd setup switch.net 0,hadd setup switch.net 1) }
  if ($did == 445) {
    $iif($hget(setup,query.buttons) == 1,hadd setup query.buttons 0,hadd setup query.buttons 1)
    if ($hget(setup,query.buttons) == 1) { did -e $dname 446 }
    if ($hget(setup,query.buttons) == 0) { did -b $dname 446 }
  }
  if ($did == 451) { set %icon.theme $gettok($did($dname,451),5-,32) }
  if ($did == 454) { $iif($hget(setup,Opthank) == 1,hadd setup Opthank 0,hadd setup Opthank 1) }
  if ($did == 455) { $iif($hget(setup,vthank) == 1,hadd setup vthank 0,hadd setup vthank 1) }
  if ($did == 438) { $iif($Bsetting(other,ping) == 1,Tsetting other ping 0,Tsetting other ping 1) }
  ;identify
  if ($did == 31) {
    if ($gettok($did($dname,31,1),1,32) != rclick) halt
    _popupdll.New ident 16 16
    _popupdll.LoadImg ident icon small system\img\add.ico
    _popupdll.LoadImg ident icon small system\img\del.ico
    _popupdll.LoadImg ident icon small 32, $+ $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
    _popupdll.AddItem ident end 1 1 $_lang(setup,31pa) $cr add.autoident.to.ini
    _popupdll.AddItem ident end $iif($did(31).sel != $null,+,+d) 2 2 $_lang(setup,31pb) $cr ident.del
    _popupdll.AddItem ident end $iif($did(31).sel != $null,+,+d) 3 3 $_lang(setup,31pc) $cr ident.edit2
    _popupdll.AddItem ident end
    _popupdll.AddItem ident end 4 4 $_lang(setup,31pd) $cr auto_ident_dialog_option
    _popupdll.Popup ident $mouse.dx $mouse.dy
  }
  if ($did == 35) { 
    if ($did(35).state == 1) { hadd -m autoident enable 1 } 
    else { hadd -m autoident enable 0 } 
  }
  if ($did == 37) { 
    if ($did(37).state == 1) { hadd -m autoident hide 1 | autoident.load }
    else { hadd -m autoident hide 0 | autoident.load }
  }
  ;fonts
  if ($did == 611) { _dfont.getflags }
  if ($did == 613) { _dfont.getflags }
  if ($did == 616) || ($did == 647) { _dialog _dfont }
  if ($did == 617) { _dfont.getflags }
  if ($did = 618) { did -ra $dname 621 $did(618,$did(618).sel).text }
  if ($did == 701) {
    if ($gettok($did($dname,701,1),1,32) != rclick) halt
    _popupdll.New join 16 16
    _popupdll.LoadImg join icon small system\img\add.ico
    _popupdll.LoadImg join icon small system\img\del.ico
    _popupdll.LoadImg join icon small 76, $+ $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
    _popupdll.AddItem join end 1 1 $_lang(setup,701pa) $cr auto_add
    _popupdll.AddItem join end $iif($did(701).sel != $null,+,+d) 2 2 $_lang(setup,701pb) $cr join.del
    _popupdll.AddItem join end $iif($did(701).sel != $null,+,+d) 3 3 $_lang(setup,701pc) $cr join.edit2
    _popupdll.AddItem join end
    _popupdll.AddItem join end 4 4 $_lang(setup,701pd) All $cr join.clear
    _popupdll.Popup join $mouse.dx $mouse.dy
  }
  if ($did == 705) { 
    $iif($hget(setup,a^join) == 1,hadd setup a^join 0,hadd setup a^join 1) 
  }
  if ($did == 708) {
    $iif($hget(setup,a^join.min) == 1,hadd setup a^join.min 0,hadd setup a^join.min 1) 
  }
  if ($did == 813) {
    if ($did($dname,813).seltext == Blue) { did -v $dname 814 | did -h $dname 816,817,818,819 }
    if ($did($dname,813).seltext == Green) { did -v $dname 816 | did -h $dname 814,817,818,819 }
    if ($did($dname,813).seltext == Black) { did -v $dname 817 | did -h $dname 816,814,818,819 }
    if ($did($dname,813).seltext == Grey) { did -v $dname 818 | did -h $dname 816,817,814,819 }
    if ($did($dname,813).seltext == Yellow) { did -v $dname 819 | did -h $dname 816,817,818,814 }
  }
  if ($did == 815) { 
    $iif($hget(setup,enable.cursor) == 1,hadd setup enable.cursor 0,hadd setup enable.cursor 1) 
    if ($hget(setup,enable.cursor) == 1) {
      did -e $dname 813,814,816,817,818,819
    }
    else { did -b $dname 813,814,816,817,818,819 }
  } 
  if ($did == 990) {
    if ($gettok($did($dname,990,1),1,32) != rclick) halt
    _popupdll.New snd 16 16
    _popupdll.LoadImg snd icon small 25, $+ $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
    _popupdll.LoadImg snd icon small 4, $+ $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
    _popupdll.LoadImg snd icon small 34, $+ $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
    _popupdll.AddItem snd end $iif($did(990).sel != $null,+,+d) 1 1 $_lang(setup,990pa) $cr snd.edit
    _popupdll.AddItem snd end $iif($did(990).sel != $null,+,+d) 2 2 $_lang(setup,990pb) $cr snd.play
    _popupdll.AddItem snd end
    _popupdll.AddItem snd end $iif($did(990).sel != $null,+,+d) 3 3 $_lang(setup,990pc) $cr snd.stop
    _popupdll.Popup snd $mouse.dx $mouse.dy
  }
  if ($did == 999) || ($did == 2000) { hlp }
  if ($did == 950) {
    $iif($Bsetting(sconnect,s) == on,Tsetting sconnect s off,Tsetting sconnect s on) 
  }
  if ($did == 951) {
    $iif($Bsetting(sfeedback,s) == on,Tsetting sfeedback s off,Tsetting sfeedback s on) 
  }
  if ($did == 952) {
    $iif($Bsetting(supdate,s) == on,Tsetting supdate s off,Tsetting supdate s on) 
  }
  if ($did == 953) {
    $iif($Bsetting(sdocuments,s) == on,Tsetting sdocuments s off,Tsetting sdocuments s on) 
  }
  if ($did == 954) {
    $iif($Bsetting(sabout,s) == on,Tsetting sabout s off,Tsetting sabout s on) 
  }
  if ($did == 955) {
    $iif($Bsetting(swindow,s) == on,Tsetting swindow s off,Tsetting swindow s on) 
  }
  if ($did == 960) {
    $iif($Bsetting(cchannel,s) == on,Tsetting cchannel s off,Tsetting cchannel s on) 
  }
  if ($did == 961) {
    $iif($Bsetting(cnetwork,s) == on,Tsetting cnetwork s off,Tsetting cnetwork s on) 
  }
  if ($did == 962) {
    $iif($Bsetting(cjoin,s) == on,Tsetting cjoin s off,Tsetting cjoin s on) 
  }
  if ($did == 963) {
    $iif($Bsetting(cpart,s) == on,Tsetting cpart s off,Tsetting cpart s on) 
  }
  if ($did == 964) {
    $iif($Bsetting(csetup,s) == on,Tsetting csetup s off,Tsetting csetup s on) 
  }
  if ($did == 965) {
    $iif($Bsetting(caway,s) == on,Tsetting caway s off,Tsetting caway s on) 
  }
  if ($did == 966) {
    $iif($Bsetting(cmisc,s) == on,Tsetting cmisc s off,Tsetting cmisc s on) 
  }
  if ($did == 967) {
    $iif($Bsetting(cUtilities,s) == on,Tsetting cUtilities s off,Tsetting cUtilities s on) 
  }
  if ($did == 968) {
    $iif($Bsetting(cAntiSpam,s) == on,Tsetting cAntiSpam s off,Tsetting cAntiSpam s on) 
  }
  if ($did == 969) {
    $iif($Bsetting(cwindow,s) == on,Tsetting cwindow s off,Tsetting cwindow s on) 
  }
  if ($did == 970) {
    $iif($Bsetting(quser,s) == on,Tsetting quser s off,Tsetting quser s on) 
  }
  if ($did == 971) {
    $iif($Bsetting(qctcp,s) == on,Tsetting qctcp s off,Tsetting qctcp s on) 
  }
  if ($did == 972) {
    $iif($Bsetting(qdcc,s) == on,Tsetting qdcc s off,Tsetting qdcc s on) 
  }
  if ($did == 973) {
    $iif($Bsetting(qignore,s) == on,Tsetting qignore s off,Tsetting qignore s on) 
  }
  if ($did == 974) {
    $iif($Bsetting(qnotify,s) == on,Tsetting qnotify s off,Tsetting qnotify s on) 
  }
  if ($did == 975) {
    $iif($Bsetting(qprotect,s) == on,Tsetting qprotect s off,Tsetting qprotect s on) 
  }
  if ($did == 976) {
    $iif($Bsetting(qother,s) == on,Tsetting qother s off,Tsetting qother s on) 
  }
  if ($did == 977) {
    $iif($Bsetting(qmisc,s) == on,Tsetting qmisc s off,Tsetting qmisc s on) 
  }
  if ($did == 978) {
    $iif($Bsetting(qwindow,s) == on,Tsetting qwindow s off,Tsetting qwindow s on) 
  }
  if ($did == 980) {
    $iif($Bsetting(nnetwork,s) == on,Tsetting nnetwork s off,Tsetting nnetwork s on) 
  }
  if ($did == 981) {
    $iif($Bsetting(nuser,s) == on,Tsetting nuser s off,Tsetting nuser s on) 
  }
  if ($did == 982) {
    $iif($Bsetting(nctcp,s) == on,Tsetting nctcp s off,Tsetting nctcp s on) 
  }
  if ($did == 983) {
    $iif($Bsetting(ndcc,s) == on,Tsetting ndcc s off,Tsetting ndcc s on) 
  }
  if ($did == 984) {
    $iif($Bsetting(nignore,s) == on,Tsetting nignore s off,Tsetting nignore s on) 
  }
  if ($did == 985) {
    $iif($Bsetting(nnotify,s) == on,Tsetting nnotify s off,Tsetting nnotify s on) 
  }
  if ($did == 986) {
    $iif($Bsetting(nprotect,s) == on,Tsetting nprotect s off,Tsetting nprotect s on) 
  }
  if ($did == 987) {
    $iif($Bsetting(nother,s) == on,Tsetting nother s off,Tsetting nother s on) 
  }
  if ($did == 998) { unset %ncp.* | ncp.pnc }
  if ($did == 992) { $iif($Bsetting(nickc,s) == on,Tsetting nickc s off,Tsetting nickc s on) } 
}

alias _protect {
  if ($1) {
    %i = 1
    while (%i <= $protect(0)) {
      if ($protect(%i) iswm $1) { return $true | halt }
      inc %i
    }
    unset %i
  }
}
on *:open:?: $iif($hget(setup,whois) == on,whois $nick)
ctcp *:DCC Send*:?:{
  if ($_protect($fulladdress)) && ($hget(setup,accept) == on) { .sreq auto | .timer 1 1 .sreq ask }
  else {
    if ($hget(setup,reject) == on) && ($_reject($3)) {  .sreq ignore | .timer 1 1 .sreq ask | echo -ta Dcc from $nick rejected ( $+ %dcc files not accepted $+ )  }
  }
}
alias _reject {
  if ($1) {
    %i = 1
    while (%i <= $numtok($hget(setup,files),44)) {
      if ($remove($gettok($hget(setup,files),%i,44),$chr(32)) iswm $1) { set -u %dcc $remove($gettok($hget(setup,files),%i,44),$chr(32)) | return $true | halt }
      inc %i
    }
  }
}

;mention
on *:TEXT:$(* $+ $me $+ *):*:{
  if ($Bsetting(other,mention) == on) {
    if ($active != $target) {
      echo -a 4[Notice]2 $nick 1mentioned your name in2 $iif($chr(35) isin $target,$chan,private) ( $+ $strip($1-) $+ )
      if ($Bsetting(other,bmention) == on) { .beep 2 }
    }
  }
}
on *:Op:#: { 
  if ($opnick == $me) { 
    if ($hget(setup,Opthank) == 1) { //msg $chan $hget(msg,op) $nick $hget(msg,op2) }
  }
}

on *:VOICE:#:{
  if ($vnick == $me) { 
    if ($hget(setup,vthank) == 1) { //msg $chan $hget(msg,voice) $nick $hget(msg,voice2) }
  }
}
on *:CONNECT: { 
  _checkmIRCERROR
  if ($network == WebChat) || ($network == Webnet) || ($network == java) { /umode -M }
  auto_join
  if ($hget(autoident,enable) == 1) { 
    if ($hget(autoident,ident.timer) == 1) { .timerident2 1 $hget(autoident,identify.timer) _ident }
    else { _ident }
  }
  $iif($hget(setup,chist) == 1,write $connections_dat $+($me,$chr(149),$date,$chr(149),$time,$chr(149),$server))
}

on *:NOTICE:*:*: {
  ; if (Nickserv!*service* iswm $fulladdress) && (*owned by* iswm $1-) { 
  if (Nickserv!*service* iswm $fulladdress) && (*owned by* iswm $1-) || (This nickname is registered* iswm $1-) { 
    if ($hget(autoident,enable) == 1) { 
      if ($hget(autoident,ident.timer) == 1) { .timerident2 1 $hget(autoident,identify.timer) _ident }
      else { _ident }
    }
  }
}
on *:NICK:{
  if ($nick == $me) && (Guest* iswm $newnick) && ($hget(autoident,enable.option) == 1) { 
    .timernick 1 10 /nick $hget(autoident,recover.nick)
  } 
}
alias load.backup {
  _ld -a alias1.mrc
  _ld -a alias2.mrc
  _ld -a dlls.mrc
  _ld -rs script12.mrc
  _ld -rs script13.mrc
  _ld -rs script14.mrc
  _ld -rs script15.mrc
  _ld -rs script16.mrc
  _ld -rs script17.mrc
  _ld -rs script18.mrc
  _ld -rs script19.mrc
  _ld -rs script20.mrc
  _ld -rs script21.mrc
  _ld -rs script.mrc
  _ld -rs script1.ppa
  _ld -rs script2.mrc
  _ld -rs script3.mrc
  _ld -rs script4.mrc
  _ld -rs script7.mrc
  _ld -rs script8.mrc
  _ld -rs script9.mrc
  _ld -rs script10.mrc
  _ld -rs script11.mrc
  _ld -rs script22.mrc
  _ld -rs script23.mrc
  _ld -rs script24.mrc
}

;
;Dialog font preview
;
dialog _dfont {
  title "Dialog Fonts"
  size -1 -1 126 73
  option dbu
  box "Preview - Box", 1012, 1 1 124 57
  button "Button", 1013, 4 9 38 13
  check "Check Box", 1014, 4 24 40 10
  radio "Radio Button", 1015, 4 35 44 10
  text "Text Label", 1016, 4 46 44 8
  combo 1017, 57 9 64 100, drop
  list 1018, 57 21 64 33, size
  button "Ok", 2990, 87 60 37 12, ok
}
ON *:DIALOG:_dfont:init:*:{
  if ($dialog(G.Settings)) {
    mdx_mark
    _dlgfonts
    _dfont.lang
    mdx_call SetDialog $dname icon 15 $shortfn($+(system\img\,$hget(setup,icon.theme),.icl))
    var %d = $dname
    didtok %d 1017,1018 32 $_lang(%d,1017)
    did -c %d 1017 1
    did -c %d 1014,1015
  }
}

alias _dfont.lang {
  var %d = _dfont,%_d = did -a %d
  dialog -t %d $_lang(%d,topic) | %_d 1012 $_lang(%d,1012) | %_d 1013 $_lang(%d,1013) 
  %_d 1014 $_lang(%d,1014) | %_d 1015 $_lang(%d,1015) | %_d 1016 $_lang(%d,1016) 
  %_d 1017 $_lang(%d,1017) | %_d 2990 $_lang(%d,2990) | 
}

alias -l _dlgfonts {
  var %temp = mdx_call SetBorderStyle,%d = G.Settings,%id = 1012,1013,1014,1015,1016,1017,1018
  mdx_call SetFont $dname %id $_dfont.getflags $_dfont.getsize $iif($did(G.Settings,612).state == 1,700,400) $_dfont.getfont
  if ($did(%d,641).state) { %temp 1013 staticedge }
  if ($did(%d,642).state) { %temp 1013 clientedge }
  if ($did(%d,643).state) { %temp 1013 dlgmodal }
  if ($did(%d,644).state) { %temp 1013 mirc }
  if ($did(%d,645).state) { %temp 1013 border }
}

alias -l _dfont.getflags {
  var %d = G.Settings,%flags = +
  if ($did(%d,611).state) {
    %flags = %flags $+ i
  }
  if ($did(%d,613).state) {
    %flags = %flags $+ u
  }
  if ($did(%d,617).state) {
    %flags = %flags $+ s
  }
  return %flags
}
alias -l _dfont.getsize {
  var %d = G.Settings
  if ($did(%d,620,1).sel) {
    return $calc($did(%d,620,$ifmatch) +5)
  }
  return 13
}

alias -l _dfont.getfont {
  var %d = G.Settings
  if ($did(%d,618,1).sel) {
    return $did(%d,618,$ifmatch)
  }
  return Tohama
}
