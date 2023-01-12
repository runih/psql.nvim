" Vim syntax file
" Language:             .pgpass PostgreSQL password file
" Maintainer:           Rúni H.Hansen <runi.hansen@okkara.net>
" Latest Revision:      2021-11-03

if exists("b:current_syntax")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn match passwdBegin                     display '^'                   nextgroup=pgpassHost
syn match pgpassHost            contained display '[a-zA-Z0-9\-\_\.]\+' nextgroup=pgpassPortColon
syn match pgpassPortColon       contained display ':'                   nextgroup=pgpassPort
syn match pgpassPort            contained display '\d\{0,5}'            nextgroup=pgpassDatabaseColon
syn match pgpassDatabaseColon   contained display ':'                   nextgroup=pgpassDatabase
syn match pgpassDatabase        contained display '[a-zA-Z0-9\-\_]\+'   nextgroup=pgpassUserColon
syn match pgpassUserColon       contained display ':'                   nextgroup=pgpassUser
syn match pgpassUser            contained display '[a-zA-Z0-9\-\_@]\+'  nextgroup=pgpassPasswordColon
syn match pgpassPasswordColon   contained display ':'                   nextgroup=pgpassPassword
syn match pgpassPassword        contained display '.*'



hi def link pgpassColon         Normal
hi def link pgpassHost          Normal
hi def link pgpassPortColon     pgpassColon
hi def link pgpassPort          Number
hi def link pgpassDatabaseColon pgpassColon
hi def link pgpassDatabase      Identifier
hi def link pgpassUserColon     pgpassColon
hi def link pgpassUser          Type
hi def link pgpassPasswordColon pgpassColon
hi def link pgpassPassword      Operator

let b:current_syntax = "pgpass"

let &cpo = s:cpo_save
unlet s:cpo_save
