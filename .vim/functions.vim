function! Winlist()
	let s:fnames = ""
	windo let s:fnames = s:fnames . expand('%:p') . "\n"
	return s:fnames
endfunction

function! HeaderExt(ext)
	let s:extregex = "\\<" . a:ext . "\\>"
	if match(g:sourceexts, s:extregex) != -1
		if (a:ext=="c") || (a:ext=="m") || (a:ext=="mm")
			let s:ext = "h"
		else
			let s:pos = matchend(g:headerexts, s:extregex)
			if (s:pos == -1)
				throw "Extension " . a:ext . " not found in headerexts: " . g:headerexts
			endif
			let s:ext = matchstr(g:headerexts, "[A-Za-z]*", s:pos+1)
		endif
		return s:ext
	else
		throw "Extension " . a:ext . " not found in headerexts: " . g:headerexts
	endif
endfunction

function! OpenInc(stem, ext)
	if (a:ext=="c")
		let s:buftype = "c"
	elseif (a:ext=="m")
		let s:buftype = "objc"
	else
		let s:buftype = "cpp"
	endif
	try
		let s:ext = HeaderExt(a:ext)
		let s:incname = a:stem . "." . s:ext
		exec "find " . s:incname
		let &ft = s:buftype
		split
		wincmd j
		b 1
		let &ft = s:buftype
	catch /^Vim\%((\a\+)\)\=:E345/
	catch /^Extension /
	endtry
endfunction

function! HTMLHilightLines(use_ft) range
	execute a:firstline . "," . a:lastline . " d h"
	new
	let &ft = a:use_ft
	put h
	1d
	runtime syntax/2html.vim
	9,$-3d h
	q!
	q!
	put! h
endfunction

function! ToggleNumbering()
	let &number=!&number
	if has("gui_running")
		let &columns=(80 + (8 * &number))
	endif
endfunction

function! ToggleFoldcolumn()
	if has("gui_running")
		let &columns=(&columns - &foldcolumn)
	endif
	let &foldcolumn=((&foldcolumn + 4) % 8)
	if has("gui_running")
		let &columns=(&columns + &foldcolumn)
	endif
endfunction

function! ReverseLines()
	let l:b = a:firstline - 1
	let l:e = a:lastline
	let l:i = l:b
	while l:i < l:e
		let l:i = l:i + 1
		exec l:i . "m" . l:b
	endwhile
endfunction

