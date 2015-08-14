let curdirname=expand("%:p:h:t")
let curfilename=curdirname . "/" . expand("%:t")
let @t="/* $Header$\n */ /**\n * @file " . curfilename . "\n * @ingroup " . curdirname . "\n */\n#include " . '"' . expand("%:t:r") . "."
let @T=HeaderExt(expand("%:e"))
let @T='"' . "\n\n"
0put t
"$put g
