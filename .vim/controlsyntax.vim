if ((&term=="ncsa" || &term=="screen.linux" || &term=="linux" || &term=="osXt" || &term=="xterm") && has("terminfo")) || (&term=="builtin_gui") || (&term=="builtin_beos-ansi")
	set icon title
	syntax on
else
	set noicon notitle
	syntax off
endif
