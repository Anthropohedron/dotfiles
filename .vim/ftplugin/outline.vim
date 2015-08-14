set ts=4 sw=4
set foldlevel=4
set makeprg=outline\ %
if version >= 600
	set foldtext=OutlineFoldText()
	map   &r    :set foldtext=foldtext()
"	map   }     ]zj
"	map   {     k[z
endif
nmap  <C-\>   :call ToggleFoldcolumn()<CR>
noremap   <C-W>   :w<ESC>:make<ESC><CR>
nmap   `        F"i
nnoremap   #        O<<ESC>aa href=""></a><ESC>3hi
nmap   (       f<<ESC>
nmap   )       f><ESC>
nmap   <C-K>   ?><ESC>c/<<ESC>>
nmap   <Tab>   >>
vmap   <Tab>   >
imap   ®       <ESC>f>a
imap   ¬       <ESC>F<i
iabbr  h1      h1</h1><ESC>4hi
iabbr  h2      h2</h2><ESC>4hi
iabbr  h3      h3</h3><ESC>4hi
iabbr  h4      h4</h4><ESC>4hi
iabbr  h5      h5</h5><ESC>4hi
iabbr  h6      h6</h6><ESC>4hi
iabbr  li      li</li><ESC>4hi
iabbr  <a      <a></a><ESC>4hi
iabbr  <i      <i</i><ESC>3hi
iabbr  <b      <b</b><ESC>3hi
