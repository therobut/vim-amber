" Vim indent file
" Language: Amber
" Maintainer: Joshua Borton
" Credits: Tim Pope (vim-pug), Joshua Borton
" Last Change: 2016 Feb 13

if exists("b:did_indent")
  finish
endif

unlet! b:did_indent
let b:did_indent = 1

setlocal autoindent
setlocal indentexpr=GetAmberIndent()
setlocal indentkeys=o,O,*<Return>,},],0),!^F

" Only define the function once.
if exists("*GetAmberIndent")
  finish
endif

let s:attributes = '\%((.\{-\})\)'
let s:tag = '\([%.#][[:alnum:]_-]\+\|'.s:attributes.'\)*[<>]*'

if !exists('g:amber_self_closing_tags')
  let g:amber_self_closing_tags = 'meta|link|img|hr|br|input'
endif

setlocal formatoptions+=r
setlocal comments+=n:\|

function! GetAmberIndent()
  let lnum = prevnonblank(v:lnum-1)
  if lnum == 0
    return 0
  endif
  let line = substitute(getline(lnum),'\s\+$','','')
  let cline = substitute(substitute(getline(v:lnum),'\s\+$','',''),'^\s\+','','')
  let lastcol = strlen(line)
  let line = substitute(line,'^\s\+','','')
  let indent = indent(lnum)
  let cindent = indent(v:lnum)
  let increase = indent + &sw
  if indent == indent(lnum)
    let indent = cindent <= indent ? -1 : increase
  endif

  let group = synIDattr(synID(lnum,lastcol,1),'name')

  if line =~ '^!!!'
    return indent
  elseif line =~ '^/\%(\[[^]]*\]\)\=$'
    return increase
  elseif line =~ '^\%(if\|else\|unless\|for\|each\|block\|mixin\|append\|case\|when\)'
    return increase
  elseif line =~ '^'.s:tag.'[&!]\=[=~-].*,\s*$'
    return increase
  elseif line == '-#'
    return increase
  elseif line =~? '^\v%('.g:amber_self_closing_tags.')>'
    return indent
  elseif group =~? '\v^%(amberAttributesDelimiter|amberClass|amberId|htmlTagName|htmlSpecialTagName|amberFilter|amberTagBlockChar)$'
    return increase
  else
    return indent
  endif
endfunction

" vim:set sw=2:
