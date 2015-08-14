command CD vert diffpatch cvs
function! CVSDiff()
   let opt = ""
   if &diffopt =~ "icase"
     let opt = opt . "-i "
   endif
   if &diffopt =~ "iwhite"
     let opt = opt . "-b "
   endif
   if v:fname_diff ==# "cvs"
	   lcd
	   call system("cvs -f diff " . opt . " " . expand("%:p") . " | tail +6 | patch -R -o " . v:fname_out . " " . v:fname_in)
"	   call system("cvsdiff " . expand("%:p") . " " . v:fname_in . " " . v:fname_out . " " . opt)
   else
	   call system("patch -o " . v:fname_out . " " . v:fname_in . " < " . v:fname_diff)
   endif
endfunction
