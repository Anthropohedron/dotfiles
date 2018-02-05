set expandtab
set cursorline cursorcolumn
set sw=2 ts=2
if &ro != 1
	%s/\s\+$//e
endif
set foldmethod=indent
set foldenable
set foldlevel=99
set iskeyword=@,48-57,_,192-255
set laststatus=2
noremap <C-T>   =%
nmap  <C-\>   :call ToggleNumbering()<CR>
if has("gui_running")
	imap   <C-Down> :cn<CR>
	imap   <C-Up>   :cp<CR>
else
	"imap   <C-D>    :cn<CR>
	"imap   <C-U>    :cp<CR>
endif
inoremap <Tab> <C-P>
noremap   >>   ==
vmap   <Tab>   =
vmap   <C-T>   =
nmap   (       lbi(<ESC>
nmap   )       hea)<ESC>
nmap   <C-K>   ^d%
nmap   ¬       <%
nmap   ®       >%

