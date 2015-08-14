syn clear
syn match cvsComment	"CVS:.*"
if !exists("did_cvslog_sentence_inits")
	let did_cvslog_sentence_inits=1
	hi link cvsComment	Comment
endif

let b:current_syntax="cvslog"
