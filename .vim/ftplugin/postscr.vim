"if &ro != 1
"	%s/[ 	][ 	]*$//e
"endif
set ai
set sw=4 ts=4
set makeprg=gv\ %\ &
set comments=n:%
imap  {         {<CR>} def<ESC>O
nmap   <C-W>    :w<CR>
nmap   \        :r !epsbgbox %<CR>
nmap   @        1Gi%!PS-Adobe-2.0<CR><ESC>
nmap   #        I%<ESC>
nmap  <C-\>     :call ToggleNumbering()<CR>
if &term=="builtin_gui"
  nmap   <C-Down> :cn<CR>
  nmap   <C-Up>   :cp<CR>
else
  nmap   <C-D>    :cn<CR>
  nmap   <C-U>    :cp<CR>
endif
inoremap   <Tab> <C-P>
nmap   <C-K>       ^d%
nmap   ¬       <%
nmap   ®       >%
