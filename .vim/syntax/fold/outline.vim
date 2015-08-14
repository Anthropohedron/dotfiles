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
