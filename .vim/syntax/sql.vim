syn case ignore
syn keyword sqlKeyword	case when coalesce references do rule join
syn keyword sqlOperator	returns currval nextval now
syn match sqlKeyword	"primary key"
syn keyword sqlType	text timestamp serial numeric real int
syn match sqlTodo "----.*$" containedin=sqlComment
syn keyword sqlTodo TODO containedin=sqlComment
hi link sqlTodo Todo
