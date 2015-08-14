if version >= 600
	syn sync fromstart
	syn region latexEnv start="\\begin{\([^}]*\)}" end="\\end{\1}" keepend fold
	set foldmethod=syntax
endif
