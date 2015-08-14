" Vim syntax file
" Language:	tf (TinyFugue)
" Maintainer:	Ken Keys <hawkeye@tf.tcp.com>
" Last change:	1998 Jun 19

" Remove any old syntax stuff hanging around
syn clear


hi tfIdentifier term=bold ctermfg=DarkGreen guifg=DarkGreen
hi tfSpecialvar term=bold ctermfg=Green guifg=Green
hi tfCmdSubGr	term=underline ctermfg=Cyan guifg=Cyan
hi tfExprSubGr	term=underline ctermfg=Green guifg=Green
hi tfParengroup	term=underline ctermfg=DarkCyan guifg=DarkCyan
hi Special	term=bold ctermfg=Blue guifg=Blue

"hi link tfIdentifier	Identifier
hi link tfVarcurly	tfIdentifier
hi link tfVarsub	tfIdentifier

syn case match

syn keyword tfSpecialvar contained	LANG		LC_ALL
syn keyword tfSpecialvar contained	LC_CTYPE	LC_TIME
syn keyword tfSpecialvar contained	MAIL		TERM
syn keyword tfSpecialvar contained	TFLIBDIR	TFPATH
syn keyword tfSpecialvar contained	TZ
syn keyword tfSpecialvar contained	auto_fg		background
syn keyword tfSpecialvar contained	backslash	bamf
syn keyword tfSpecialvar contained	beep		bg_output
syn keyword tfSpecialvar contained	binary_eol	borg
syn keyword tfSpecialvar contained	cleardone	clearfull
syn keyword tfSpecialvar contained	connect		emulation
syn keyword tfSpecialvar contained	gag		gethostbyname
syn keyword tfSpecialvar contained	gpri		hilite
syn keyword tfSpecialvar contained	hiliteattr	histsize
syn keyword tfSpecialvar contained	hook		hpri
syn keyword tfSpecialvar contained	insert		isize
syn keyword tfSpecialvar contained	istrip		kecho
syn keyword tfSpecialvar contained	kprefix		login
syn keyword tfSpecialvar contained	lp		lpquote
syn keyword tfSpecialvar contained	maildelay	matching
syn keyword tfSpecialvar contained	max_iter	max_recur
syn keyword tfSpecialvar contained	mecho		meta_esc
syn keyword tfSpecialvar contained	more		mprefix
syn keyword tfSpecialvar contained	oldslash	pedantic
syn keyword tfSpecialvar contained	prompt_sec	prompt_usec
syn keyword tfSpecialvar contained	proxy_host	proxy_port
syn keyword tfSpecialvar contained	ptime		qecho
syn keyword tfSpecialvar contained	qprefix		quiet
syn keyword tfSpecialvar contained	quitdone	redef
syn keyword tfSpecialvar contained	refreshtime	scroll
syn keyword tfSpecialvar contained	shpause		snarf
syn keyword tfSpecialvar contained	sockmload	status_attr
syn keyword tfSpecialvar contained	status_fields	status_pad
syn keyword tfSpecialvar contained	sub		tabsize
syn keyword tfSpecialvar contained	telopt		time_format
syn keyword tfSpecialvar contained	visual		watchdog
syn keyword tfSpecialvar contained	watchname	wordpunct
syn keyword tfSpecialvar contained	wrap		wraplog
syn keyword tfSpecialvar contained	wrapsize	wrapspace

syn case ignore

" String and Character constants
syn region tfString		contained start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=tfSpecialChar,tfCharError
syn region tfString		contained start=+'+ skip=+\\\\\|\\'+ end=+'+ contains=tfSpecialChar,tfCharError
syn region tfString		contained start=+`+ skip=+\\\\\|\\`+ end=+`+ contains=tfSpecialChar,tfCharError
syn match tfSpecialChar		"\\."
syn match tfSpecialChar		"\\0[0-7]*"
syn match tfSpecialChar		"\\0x[0-9a-f]\+"
syn match tfSpecialChar		"\\[1-9][0-9]*"

" bad octal and hex chars
syn match tfCharError		"\\0[0-7]*[89]"
syn match tfCharError		"\\0x[0-9a-f]*[g-z]"

"syn match tfCmd "/[a-z0-9_]\+\>" nextgroup=tfOptions
syn region tfCmd start="/[a-z0-9_]\+\>" end="" nextgroup=tfOptions
syn region tfOptions contained start="\s*-[a-z]\+" skip="\s\+-" end="[ =]" contains=tfComment,tfMissingContinue,tfContinue,tfContinueSpace,tfString,tfIntopt,tfVarsub,tfExprsub,tfCmdsub
syn match tfIntopt	contained "[0-9]\+"

syn region tfWrappedCmd start="^" skip="^.*\\$" end="^[^;].*$\|^$" keepend contains=tfCmdseparator,tfComment,tfContinueSpace,tfCmd,tfControl,tfTest,tfIf,tfWhile,tfVarsub,tfExprsub,tfCmdsub,tfSpecialChar,tfWhileError,tfIfError,tfCharError

syn region tfIllegalCmd		start="^[^ /;]" skip='^.*\\$' end='^[^;].*$\|^$' keepend
syn region tfIllegalCmd		start="^\s\+[^/ ]" skip='^.*\\$' end='^[^;].*$\|^$' keepend
if !exists("tf_allow_initial_indent")
  syn region tfIllegalCmd	start="^\s\+" skip='^.*\\$' end='^[^;].*$\|^$' keepend
endif


" Continue error: \ followed by whitespace at end of line
syn match tfContinueSpace	"\\\s\+$"

syn match tfIdentifier	contained transparent "\<[A-Za-z_][A-Za-z0-9_]*\>"
syn region tfVardefault	contained transparent start="-" matchgroup=tfIdentifier end="}" contains=tfVarsub,tfCmdsub,tfExprsub,tfMacsub,tfSpecialChar,tfCharError

syn region tfCmdsub	contained matchgroup=tfCmdSubGr start='$\+(' skip='\\)' end=')' contains=tfCmdseparator,tfCmdsub,tfExprsub,tfVarsub,tfMacsub,tfSpecialChar,tfCharError,tfComment,tfMissingContinue,tfContinue,tfContinueSpace

syn region tfExprsub	contained matchgroup=tfExprSubGr start='$\+\[' end=']' contains=tfComment,tfMissingContinue,tfContinue,tfContinueSpace,tfInteger,tfFloat,tfString,tfIdentifier,tfVarcurly,tfVarsub,tfMacsub,tfCmdsub,tfParen,tfParenError,tfExprError
syn region tfMacsub	contained start='$\+{' end='}' contains=tfIdentifier,tfVarsub
syn match  tfMacsub	contained "$\+[A-Za-z0-9_]\+"
syn region tfVarsub	contained matchgroup=tfIdentifier start='%%*{' end='}' keepend contains=tfSpecialvar,tfVardefault,tfVarillegal
syn region tfVarcurly	contained matchgroup=tfIdentifier start='{' end='}' keepend contains=tfSpecialvar,tfVardefault,tfVarillegal

syn region tfTest	contained transparent matchgroup=tfControl start='/@\=\(test\|return\|result\)\>' end='%\+;'me=s-1 keepend contains=tfComment,tfMissingContinue,tfContinue,tfContinueSpace,tfInteger,tfFloat,tfString,tfIdentifier,tfVarcurly,tfVarsub,tfMacsub,tfCmdsub,tfParen,tfParenError

syn case ignore
syn region  tfIdentifier   contained start="[a-z_]"rs=s end="[a-z0-9_]*" contains=tfSpecialvar
syn case match

syn match  tfVarsub		contained "%%*\([*?#]\|-\=L\=[0-9]\+\|[A-Za-z0-9_]\+\>\)"

syn match  tfCmdseparator	contained "%%*[;\\]"


syn match tfIfError	"/then\>"
syn match tfIfError	"/elseif\>"
syn match tfIfError	"/else\>"
syn match tfIfError	"/endif\>"
syn match tfWhileError	"/do\>"
syn match tfWhileError	"/done\>"

syn match tfControl	"/\(break\|exit\)\>"

syn match tfExprError	contained "||\+\|&&\+\|%[^%{]\|$[^${(]\|[[@#;}^]"

syn region tfWhile 	contained matchgroup=tfControl transparent start='/while\s\+(' end=')'                nextgroup=tfWhilebody contains=tfComment,tfMissingContinue,tfContinue,tfContinueSpace,tfInteger,tfFloat,tfString,tfIdentifier,tfVarcurly,tfVarsub,tfMacsub,tfCmdsub,tfParen,tfExprError,tfSquareError
syn region tfWhile 	contained matchgroup=tfControl transparent start='/while\s\+[^\s(]'rs=e-1 end='/do\>' nextgroup=tfWhilebody contains=tfCmdseparator,tfComment,tfMissingContinue,tfContinue,tfContinueSpace,tfCmd,tfControl,tfTest,tfVarsub,tfExprsub,tfMacsub,tfCmdsub,tfSpecialChar,tfCharError

syn region tfWhilebody 	contained matchgroup=tfControl transparent start='' end='/done\>' contains=tfCmdseparator,tfComment,tfMissingContinue,tfContinue,tfContinueSpace,tfCmd,tfControl,tfTest,tfIf,tfWhile,tfVarsub,tfExprsub,tfMacsub,tfCmdsub,tfSpecialChar,tfCharError

syn region tfIf	 	contained matchgroup=tfControl transparent start='/if\s\+(' end=')'                  nextgroup=tfIfbody contains=tfComment,tfMissingContinue,tfContinue,tfInteger,tfFloat,tfString,tfIdentifier,tfVarcurly,tfVarsub,tfMacsub,tfCmdsub,tfParen,tfExprError
syn region tfIf	 	contained matchgroup=tfControl transparent start='/if\s\+[^\s(]'rs=e-1 end='/then\>' nextgroup=tfIfbody contains=tfCmdseparator,tfComment,tfMissingContinue,tfContinue,tfContinueSpace,tfCmd,tfControl,tfTest,tfVarsub,tfExprsub,tfMacsub,tfCmdsub,tfSpecialChar,tfCharError

syn region tfIfbody 	contained matchgroup=tfControl transparent start='' end='/endif\>' contains=tfCmdseparator,tfComment,tfMissingContinue,tfContinue,tfContinueSpace,tfCmd,tfControl,tfTest,tfElseif,tfElse,tfIf,tfWhile,tfVarsub,tfExprsub,tfMacsub,tfCmdsub,tfSpecialChar,tfCharError

syn match tfElse 	contained '/else\>'

syn region tfElseif 	contained matchgroup=tfControl transparent start='/elseif\s\+(' end=')'                  contains=tfComment,tfMissingContinue,tfContinue,tfInteger,tfFloat,tfString,tfIdentifier,tfVarcurly,tfVarsub,tfMacsub,tfCmdsub,tfParen,tfExprError
syn region tfElseif 	contained matchgroup=tfControl transparent start='/elseif\s\+[^\s(]'rs=e-1 end='/then\>' contains=tfCmdseparator,tfComment,tfMissingContinue,tfContinue,tfContinueSpace,tfCmd,tfControl,tfTest,tfVarsub,tfExprsub,tfMacsub,tfCmdsub,tfSpecialChar,tfCharError

syn case match


"catch errors caused by wrong parenthesis
syn region tfParen		contained matchgroup=tfParengroup start='(' end=')' contains=tfComment,tfMissingContinue,tfContinue,tfContinueSpace,tfInteger,tfFloat,tfString,tfIdentifier,tfVarcurly,tfVarsub,tfMacsub,tfCmdsub,tfParen,tfExprError
syn match tfParenError		")"
syn match tfCurlyError		"}"
syn match tfSquareError		"]"

" integer
syn match tfInteger	contained "\<[0-9]\+\>"

" number with decimal, optional exponent
syn match tfFloat	contained "\<[0-9]\+\.[0-9]*\(e[-+]\=[0-9]\+\)\=\>"
" number with no decimal, exponent
syn match tfFloat	contained "\<[0-9]\+\(e[-+]\=[0-9]\+\)\>"
" number with leading decimal, optional exponent
syn match tfFloat	contained "[0-9]*\.[0-9]\+\(e[-+]\=[0-9]\+\)\=\>"

" Comments
syn match tfComment		"^;.*$"

if !exists("did_tf_syntax_inits")
  let did_tf_syntax_inits = 1
  " The default methods for highlighting.  Can be overridden later
  hi link tfMacsub		tfIdentifier
  hi link tfExprError		tfError
  hi link tfIfError		tfError
  hi link tfWhileError		tfError
  hi link tfElse		tfControl
  hi link tfControl		Statement
  hi link tfRepeat		Repeat
  hi link tfCharacter		Character
  hi link tfSpecialChar		tfSpecial
  hi link tfCmdseparator	tfSpecial
  hi link tfInteger		Number
  hi link tfFloat		Number
  hi link tfIntopt		Number
  hi link tfNumber		Number
  hi link tfContinueError	tfError
  hi link tfContinueSpace	tfError
  hi link tfMissingContinue	tfError
  hi link tfCharError		tfError
  hi link tfParenError		tfError
  hi link tfVarillegal		tfError
  hi link tfOperator		Operator
  hi link tfIllegalCmd		tfError
  hi link tfStatement		Statement
  hi link tfPreCondit		PreCondit
  hi link tfType		Type
  hi link tfEolError		tfError
  hi link tfString		String
  hi link tfComment		Comment
  hi link tfSpecial		SpecialChar
  hi link tfTodo		Todo
  hi link tfError		Error
endif

syn sync match tfSyncEOL grouphere NONE "^[^;].*[^\\]$"
syn sync match tfSyncEOL grouphere NONE "^$"

let b:current_syntax = "tf"

" vim: ts=8
