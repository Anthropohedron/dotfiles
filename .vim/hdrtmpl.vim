let curdirname=expand("%:p:h:t")
let curfilename=curdirname . "/" . expand("%:t")
let @t="i\e" . expand("%:t") . "\e.\e"
@t
.!tr '[.a-z]' '[_A-Z]'
d n
let @n=substitute(@n, "\n", "", "")
let @t="/* $Header$\n */ /**\n * @addtogroup " . curdirname . " */ /** @{ \n * @file " . curfilename . "\n */\n#ifndef " . @n . "\n#define " . @n . "\n"
if &ft=="c"
	let @T="#ifdef __cplusplus\n" . 'extern "C" {' . "\n#endif\n"
endif
let @T="\n\n\n"
if &ft=="c"
	let @T="#ifdef __cplusplus\n}\n#endif\n"
	let @T="#endif /* " . @n . " */\n/** @} */"
else
	let @T="#endif //" . @n . "\n/// @}"
endif
"let @T="#endif //" . @n . @g
0put t
"set ft=cpp
