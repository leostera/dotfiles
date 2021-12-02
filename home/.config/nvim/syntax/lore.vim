" Vim syntax file
" Language: Lore
" Maintainer: Leandro Ostera <leandro@abstractmachines.dev>

if exists("b:current_syntax")
  finish
endif


" 
syntax keyword loreLangTodo TODO FIXME NOTE
syntax match loreLangComment "#.*$" contains=loreLangTodo
" 
" syn region loreLangString start='"' end='"' contained
" syn region loreLangBlock start="{" end="}" fold transparent
" 
" 
" hi def link loreLangTodo      Todo
" hi def link loreLangComment   Comment
" hi def link loreLangString    String
" hi def link loreLangBlock     Operator
"
" syn match loreLangPrefix '@[a-zA-Z]\+[/]\?'
" syn match loreLangUri '[a-z0-9][a-z0-9/]*:[a-zA-Z0-9()+,-.:=@;$_!*%/?#]\+'
syntax keyword loreLangKeywords as attr in kind prefix rel using

syntax match loreLangCodepointEscape /\(\\U\x\{8\}\|\\u\x\{4\}\)/ contained contains=NONE
syntax match loreLangPrefix /@[a-zA-Z0-9]*/ contains=loreLangCodepointEscape oneline
syntax match loreLangUri /@[a-zA-Z0-9]*\/[^<>'{}|^`\u00-\u20]*/ contains=loreLangCodepointEscape,loreLangPrefix oneline
syntax match loreLangUri /[^<>'{}|^`\u00-\u20]*:[^<>'{}|^`\u00-\u20]*/ contains=loreLangCodepointEscape oneline
"
"
highlight link loreLangKeywords  Keyword
highlight link loreLangUri       Identifier
highlight link loreLangPrefix    Type
highlight link loreLangTodo      Todo
highlight link loreLangComment   Comment
