;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                              ;;
;;          base64 encoder/decoder            ;;
;;            coded by necronomi              ;;
;;    (aeternus_immortalis@hotmail.com)        ;;
;;        coded on Fri, Nov 10, 2006          ;;
;;                                              ;;
;;  If you find any bugs or problems, please  ;;
;;      post a response and let me know        ;;
;;                                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;                                              ;;
;;  Either copy and paste this into your        ;;
;;  remotes, or save the file and type          ;;
;;  /load -rs C:\path\to\file\file.ext          ;;
;;                                              ;;
;;  Usage:                                    ;;
;;    $base64(text).enc to encode text          ;;
;;    $base64(text).dec to decode text          ;;
;;                                              ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

alias base64 {
  set %b64 ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/
  if (enc* iswm $prop) {
    var %x = $len($1-), %i = 0, %bstr = ""
    while (%i < %x) {
      inc %i 1
      %bstr = %bstr $+ $base($asc($mid($1-,%i,1)),10,2,8)
    }
    var %x = $len(%bstr), %i = 1, %bc = "", %p = $calc($len(%bstr) % 6), %bits = ""
    while (%i < %x) {
      %bc = $mid(%bstr,%i,6)
      if ($len(%bc) < 6) { %bc = %bc $+ $str(0,$calc(6 - $len(%bc))) }
      %bits = %bits $+ $mid(%b64,$calc($base(%bc,2,10) + 1),1)
      inc %i 6
    }
    if (%p > 0) {
      if (%p == 2) %bits = %bits $+ ==
      elseif (%p == 4) %bits = %bits $+ =
    }
    return %bits
  }
  elseif (dec* iswm $prop) {
    var %x = $len($1), %i = 0, %bstr = "", %p = $numtok($1,$asc(=)), %pos = 0, %asc = 0
    while (%i < %x) {
      inc %i 1
      %pos = $poscs(%b64,$mid($1,%i,1),1)
      if (%pos > 0) { %pos = $calc(%pos - 1) }
      %bstr = %bstr $+ $base(%pos,10,2,6)
    }
    var %x = $len(%bstr), %i = 1, %text = ""
    while (%i < %x) {
      %asc = $base($mid(%bstr,%i,8),2,10)
      if (%asc == 32) { %text = %text $chr(%asc) }
      else { %text = %text $+ $chr(%asc) }
      inc %i 8
    }
    return %text
  }
}
