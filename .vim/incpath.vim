if (expand("%:e")=="C") || (expand("%:e")=="c") || (expand("%:e")=="cc") || (expand("%:e")=="cpp") || (expand("%:e")=="cxx")
	set path=.,src/**/include/**;$HOME,/usr/include,/usr/include/qt*,/usr/include/qwt,/usr/include/c++/**1
	if !exists("b:tmppath")
		let b:tmppath = system("incpath " . expand("%:r") . ".dep")
	endif
	if strlen(b:tmppath)
		let &path = b:tmppath . &path
	else
		unlet b:tmppath
	endif
endif
