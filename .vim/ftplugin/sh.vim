let b:is_posix=1
set ts=8 sw=8 noexpandtab
nmap   Q       Oecho "" >&2<ESC>4hi
nmap   <C-W>   :w<CR>:!chmod u+x %<CR><C-L>
nmap   #       0i#<ESC>
nmap   @       :0i<CR>#!/bin/sh<CR>.<CR>
nmap   <Tab>   >>
vmap   <Tab>   >
nmap   <C-K>   ^d%
nmap   ¬       <%
nmap   ®       >%
