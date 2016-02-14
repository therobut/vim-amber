" Vim syntax file
" Language: Amber
" Maintainer: Joel Cain
" Credits: Tim Pope, Joshua Borton
" Filenames: *.amber

if exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'amber'
endif

silent! syntax include @htmlCoffeescript syntax/coffee.vim
unlet! b:current_syntax
silent! syntax include @htmlStylus syntax/stylus.vim
unlet! b:current_syntax
silent! syntax include @htmlCss syntax/css.vim
unlet! b:current_syntax
silent! syntax include @htmlMarkdown syntax/markdown.vim
unlet! b:current_syntax

syn case match

syn region  javascriptParenthesisBlock start="\[" end="\]" contains=@htmlJavascript contained keepend
syn cluster htmlJavascript add=javascriptParenthesisBlock

syn region  amberJavascript matchgroup=amberJavascriptOutputChar start="[!&]\==\|\~" skip=",\s*$" end="$" contained contains=@htmlJavascript keepend
syn region  amberJavascript matchgroup=amberJavascriptChar start="-" skip=",\s*$" end="$" contained contains=@htmlJavascript keepend
syn cluster amberTop contains=amberBegin,amberComment,amberHtmlComment,amberJavascript
syn match   amberBegin "^\s*\%([<>]\|&[^=~ ]\)\@!" nextgroup=amberTag,amberClassChar,amberIdChar,amberPlainChar,amberJavascript,amberScriptConditional,amberScriptStatement,amberPipedText
syn match   amberTag "+\?\w\+\%(:\w\+\)\=" contained contains=htmlTagName,htmlSpecialTagName nextgroup=@amberComponent
syn cluster amberComponent contains=amberAttributes,amberIdChar,amberBlockExpansionChar,amberClassChar,amberPlainChar,amberJavascript,amberTagBlockChar,amberTagInlineText
syn match   amberComment '\s*\/\/.*$'
syn region  amberCommentBlock start="\z(\s*\)\/\/.*$" end="^\%(\z1\s\|\s*$\)\@!" keepend 
syn region  amberHtmlConditionalComment start="<!--\%(.*\)>" end="<!\%(.*\)-->"
syn region  amberAttributes matchgroup=amberAttributesDelimiter start="\[" end="\]" contained contains=@htmlJavascript,amberHtmlArg,htmlArg,htmlEvent,htmlCssDefinition nextgroup=@amberComponent
syn match   amberClassChar "\." contained nextgroup=amberClass
syn match   amberBlockExpansionChar ":\s\+" contained nextgroup=amberTag,amberClassChar,amberIdChar
syn match   amberIdChar "#[[{]\@!" contained nextgroup=amberId
syn match   amberClass "\%(\w\|-\)\+" contained nextgroup=@amberComponent
syn match   amberId "\%(\w\|-\)\+" contained nextgroup=@amberComponent
syn region  amberDocType start="^\s*\(!!!\|doctype\)" end="$"
" Unless I'm mistaken, syntax/html.vim requires
" that the = sign be present for these matches.
" This adds the matches back for amber.
syn keyword amberHtmlArg contained href title

syn match   amberPlainChar "\\" contained
syn region  amberInterpolation matchgroup=amberInterpolationDelimiter start="[#!]{" end="}" contains=@htmlJavascript
syn match   amberInterpolationEscape "\\\@<!\%(\\\\\)*\\\%(\\\ze#{\|#\ze{\)"
syn match   amberTagInlineText "\s.*$" contained contains=amberInterpolation,amberTextInlineAmber
syn region  amberPipedText matchgroup=amberPipeChar start="|" end="$" contained contains=amberInterpolation,amberTextInlineAmber nextgroup=amberPipedText skipnl
syn match   amberTagBlockChar "\.$" contained nextgroup=amberTagBlockText,amberTagBlockEnd skipnl
syn region  amberTagBlockText start="\%(\s*\)\S" end="\ze\n" contained contains=amberInterpolation,amberTextInlineAmber nextgroup=amberTagBlockText,amberTagBlockEnd skipnl
syn region  amberTagBlockEnd start="\s*\S" end="$" contained contains=amberInterpolation,amberTextInlineAmber nextgroup=amberBegin skipnl
syn region  amberTextInlineAmber matchgroup=amberInlineDelimiter start="#\[" end="]" contains=amberTag keepend

syn region  amberJavascriptFilter matchgroup=amberFilter start="^\z(\s*\):javascript\s*$" end="^\%(\z1\s\|\s*$\)\@!" contains=@htmlJavascript
syn region  amberMarkdownFilter matchgroup=amberFilter start=/^\z(\s*\):\%(markdown\|marked\)\s*$/ end=/^\%(\z1\s\|\s*$\)\@!/ contains=@htmlMarkdown
syn region  amberStylusFilter matchgroup=amberFilter start="^\z(\s*\):stylus\s*$" end="^\%(\z1\s\|\s*$\)\@!" contains=@htmlStylus
syn region  amberPlainFilter matchgroup=amberFilter start="^\z(\s*\):\%(sass\|less\|cdata\)\s*$" end="^\%(\z1\s\|\s*$\)\@!"

syn match  amberScriptConditional "^\s*\<\%(if\|else\|else if\|elif\|unless\|while\|until\|case\|when\|default\)\>[?!]\@!"
syn match  amberScriptStatement "^\s*\<\%(each\|for\|block\|prepend\|append\|mixin\|extends\|include\)\>[?!]\@!"
syn region  amberScriptLoopRegion start="^\s*\(for \)" end="$" contains=amberScriptLoopKeywords
syn keyword  amberScriptLoopKeywords for in contained

syn region  amberJavascript start="^\z(\s*\)script\%(:\w\+\)\=" end="^\%(\z1\s\|\s*$\)\@!" contains=@htmlJavascript,amberJavascriptTag,amberCoffeescriptFilter keepend 

syn region  amberCoffeescriptFilter matchgroup=amberFilter start="^\z(\s*\):coffee-\?script\s*$" end="^\%(\z1\s\|\s*$\)\@!" contains=@htmlCoffeescript contained
syn region  amberJavascriptTag contained start="^\z(\s*\)script\%(:\w\+\)\=" end="$" contains=amberBegin,amberTag
syn region  amberCssBlock        start="^\z(\s*\)style" nextgroup=@amberComponent,amberError  end="^\%(\z1\s\|\s*$\)\@!" contains=@htmlCss keepend

syn match  amberError "\$" contained

hi def link amberPlainChar              Special
hi def link amberScriptConditional      PreProc
hi def link amberScriptLoopKeywords     PreProc
hi def link amberScriptStatement        PreProc
hi def link amberHtmlArg                htmlArg
hi def link amberAttributeString        String
hi def link amberAttributesDelimiter    Identifier
hi def link amberIdChar                 Special
hi def link amberClassChar              Special
hi def link amberBlockExpansionChar     Special
hi def link amberPipeChar               Special
hi def link amberTagBlockChar           Special
hi def link amberId                     Identifier
hi def link amberClass                  Type
hi def link amberInterpolationDelimiter Delimiter
hi def link amberInlineDelimiter        Delimiter
hi def link amberFilter                 PreProc
hi def link amberDocType                PreProc
hi def link amberComment                Comment
hi def link amberCommentBlock           Comment
hi def link amberHtmlConditionalComment amberComment

let b:current_syntax = "amber"

if main_syntax == "amber"
  unlet main_syntax
endif
