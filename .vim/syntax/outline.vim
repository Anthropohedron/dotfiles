if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if version < 600
	syn match olcomment "^#.*"
	syn match olL0 "^[^\t#].*"
	syn match olL1 "^[\t][^\t].*"
	syn match olL2 "^[\t]\{2}[^\t].*"
	syn match olL3 "^[\t]\{3}[^\t].*"
	syn match olL4 "^[\t]\{4}[^\t].*"
	syn match olL5 "^[\t]\{5}[^\t].*"
	syn match olL6 "^[\t]\{6}[^\t].*"
	syn match olL7 "^[\t]\{7}[^\t].*"
	syn match olL8 "^[\t]\{8}[^\t].*"
	syn match olL9 "^[\t]\{9}[^\t].*"
else
	syn sync fromstart
	syn region olcomment start="^#" skip="\n#" end="\n" keepend fold
	syn region olL9 start="^[\t]\{9}[^\t]" skip="\n\(\t\{10}\|#\)" end="\n" keepend fold
	syn region olL8 start="^[\t]\{8}[^\t]" skip="\n\(\t\{9}\|#\)"  end="\n" keepend fold contains=olL9,olcomment
	syn region olL7 start="^[\t]\{7}[^\t]" skip="\n\(\t\{8}\|#\)"  end="\n" keepend fold contains=olL9,olL8,olcomment
	syn region olL6 start="^[\t]\{6}[^\t]" skip="\n\(\t\{7}\|#\)"  end="\n" keepend fold contains=olL9,olL8,olL7,olcomment
	syn region olL5 start="^[\t]\{5}[^\t]" skip="\n\(\t\{6}\|#\)"  end="\n" keepend fold contains=olL9,olL8,olL7,olL6,olcomment
	syn region olL4 start="^[\t]\{4}[^\t]" skip="\n\(\t\{5}\|#\)"  end="\n" keepend fold contains=olL9,olL8,olL7,olL6,olL5,olcomment
	syn region olL3 start="^[\t]\{3}[^\t]" skip="\n\(\t\{4}\|#\)"  end="\n" keepend fold contains=olL9,olL8,olL7,olL6,olL5,olL4,olcomment
	syn region olL2 start="^[\t]\{2}[^\t]" skip="\n\(\t\{3}\|#\)"  end="\n" keepend fold contains=olL9,olL8,olL7,olL6,olL5,olL4,olL3,olcomment
	syn region olL1 start="^[\t]\{1}[^\t]" skip="\n\(\t\{2}\|#\)"  end="\n" keepend fold contains=olL9,olL8,olL7,olL6,olL5,olL4,olL3,olL2,olcomment
	syn region olL0 start="^[^\t#]"        skip="\n\(\t\{1}\|#\)"  end="\n" keepend fold contains=olL9,olL8,olL7,olL6,olL5,olL4,olL3,olL2,olL1,olcomment
	set foldmethod=syntax
	function! OutlineFoldText()
	  let line = getline(v:foldstart)
	"  let line = substitute(line, '^\(\t*\)\t\([^\t]\)', '\1+\2', '')
	  let sub = '+'
	  let subcount = &ts - 1
	  while subcount
	    let sub = '-' . sub
	    let subcount = subcount - 1
	  endw
	  let line = substitute(line, '\t', sub, 'g')
	  return line
	endfunction
endif
if version >= 508 || !exists("did_outline_syntax_inits")
  if version < 508
    let did_outline_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink olcomment	Normal
  HiLink olL0	Statement
  HiLink olL1	Type
  HiLink olL2	String
  HiLink olL3	Identifier
  HiLink olL4	Comment
  HiLink olL5	PreProc
  HiLink olL6	String
  HiLink olL7	Identifier
  HiLink olL8	Comment
  HiLink olL9	PreProc
  delcommand HiLink
endif
let b:current_syntax = "outline"

