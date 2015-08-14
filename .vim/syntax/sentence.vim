" Vim syntax file
" Language:	Sentence parse trees
" Last change:	September 15, 1998

" remove any old syntax stuff hanging around
syn clear

syn match words		"[^ \t]" contains=paren,NPstart,nonTerminal
syn match paren		"[()]"
syn match refDelim	contained "[-#]"
syn match refDelim	contained "\~[0-9]\+"
syn match refID		contained "[0-9]\+\~\=" contains=refDelim
syn match NPstart	"(NP\(-[A-Z]\+\)\=\(#-[0-9]\+\(\~[0-9]\+\)\=\)\="lc=1 contains=refID,refDelim
syn match nonTerminal   "([^ \tA-Za-z]*[ \n\t]"lc=1
syn match nonTerminal	"(-NONE-[ \n\t]*[^)]*"lc=1
syn match nonTerminal	"([A-Z]\+\(-\=[A-Z]\+\)\=[^ \n\t]*"lc=1 contains=delimiter,NPstart

if !exists("did_sentence_syntax_inits")
  let did_sentence_syntax_inits= 1
  hi link words			Statement
  hi link paren			Delimiter
  hi link refDelim		Normal
  hi link refID			Constant
  hi link nonTerminal		Delimiter
  hi link NPstart		Type
endif

let b:current_syntax = "sentence"

