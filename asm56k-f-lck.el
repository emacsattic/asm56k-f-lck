;; Version: asm56k-f-lck.el     1.0 20 Sep 1995
;; Font Lock Keywords for Motorola 56000 DSP assembly language
;;
;; Copyright (C) 1994 Mitch Chapman
;;

;; Author: Mitch Chapman
;;          This module was derived from the c-mode font-lock keywords
;;          provided with GNU emacs 19.22 to fontify buffers for
;;          Java.  As font-lock.el is distributed under the terms
;;          of the GNU General Public License, so is this code.
;;          (See below.)

;;         Hacked majorly by Luis Fernandes to handle Motorola 5000
;;         DSP assembly language: added 56K keywords, and changed
;;         regexps to handle jump-labels.

;; Maintainer: none
;; Keywords: languages, faces, asm

;; This file is *NOT* part of GNU Emacs.

;; asm56k-f-lck.el is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; asm56k-f-lck.el is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with asm56k-f-lck.el; see the file COPYING.  If not, write to
;; the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139,
;; USA.

;;; Commentary:

;; This module defines font-lock keywords and regular expressions for
;; asm-mode buffers.  You can use these definitions in conjunction
;; with font-lock.el to "fontify" assembly-language buffers.

;; I use this:

;;(autoload 'asm-mode "asm-mode" "Assembler mode" t nil)
;;(add-hook 'asm-mode-hook
;;                '(lambda ()
;;                   (load-library "asm56k-f-lck")
;;                   (font-lock-mode 1)))

(defconst asm-font-lock-keywords-1 nil
 "For consideration as a value of `asm-font-lock-keywords'.
This does fairly subdued highlighting.")

(defconst asm-font-lock-keywords-2 nil
 "For consideration as a value of `asm-font-lock-keywords'.
This does a lot more highlighting.")

(let ((storage (concat "ds\\|dc\\|dsm\\|equ"))

      (math "add\\|sub\\|mpy\\|mpyr\\|mal\\|mac\\|macr\\|malr\\|div\\|addl\\|addr\\|asl\\|asr")

      (org "org")

      (registers "[abxy][01]\\|[rnm][0-7]")

      (reserved-words
       '("move" "movem" "asr" "endm" "nop" "rts" "rti" "rnd" "do" "dup" "rep"
                 "bset" "bclr" "eor" "movep" "and" "or" "btst" "bchg" "clr" "lsl" "end"
                 "jset" "jsr" "jclr" "jmp"
                 "jcc" "jscc" "jcs" "jscs" "jec" "jsec" "jeq" "jseq" "jge" "jseg"
                 "jgt" "jsgt" "jlc" "jslc" "jle" "jsle" "jls" "jsls" "jlt" "jslt"
                 "jmi" "jsmi" "jne" "jsne" "jnr" "jsnr" "jpl" "jspl" "jrn" "jsrn"
                 ))

      (ctoken "[a-zA-Z0-9_:~*]+"))

  (setq asm-font-lock-keywords-1
   (list

    '(";.*$" . font-lock-comment-face)    ;; fontify comments.

    ;; fontify the labels at the start of any line
    (list (concat
           "^" ctoken "[ \t]")
          0 'font-lock-function-name-face)))

  (setq asm-font-lock-keywords-2
   (append asm-font-lock-keywords-1
    (list
         '("[ \t,]x:" . font-lock-doc-string-face)
         '("[ \t,]y:" . font-lock-type-face)
         '("'.*'" . font-lock-string-face)    ; strings for includes, etc

     (cons (concat "\\<\\(" storage "\\)\\>") 'font-lock-string-face)
     (cons (concat "\\<\\(" registers "\\)\\>") 'font-lock-string-face)
     (cons (concat "\\<\\(" org "\\)\\>") 'font-lock-doc-string-face)
     (cons (concat "\\<\\(" math "\\)\\>") 'font-lock-type-face)

     ;;
     ;; fontify all builtin tokens
            (cons (concat
                   "[ \t]\\("
                   (mapconcat 'identity reserved-words "\\|")
                   "\\)[ \t\n(){};,]")
                  1)
            (cons (concat
                   "^\\("
                   (mapconcat 'identity reserved-words "\\|")
                   "\\)[ \t\n(){};,]")
                  1)
            )))
  )

; default to the gaudier variety:
(defvar asm-font-lock-keywords asm-font-lock-keywords-2
  "Additional expressions to highlight in Assembler mode.")

;; Plug in the asm font-lock keywords, so they'll be used
;; automatically when you're in asm-mode.
(add-hook 'font-lock-mode-hook
          (function
           (lambda ()
             (if (eq major-mode 'asm-mode)
                 (setq font-lock-keywords asm-font-lock-keywords)))))

(provide 'asm56k-f-lck)
