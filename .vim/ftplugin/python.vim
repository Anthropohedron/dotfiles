nmap   Q       Oprint >> stderr, ""<ESC>i
nmap   @       :0i<CR>#!/usr/bin/env python<CR><CR>from sys import stderr<CR>.<CR>
nmap   <C-W>   :w<CR>:!chmod u+x %<CR><C-L>
nmap   #       :set paste<CR>0i#<ESC>:set nopaste<CR><C-L>
nmap   <Tab>   >>
vmap   <Tab>   >
nmap   <C-K>   ^d%
nmap   ¬       <%
nmap   ®       >%
set expandtab ts=4 sw=4
set indentkeys+=#
set noai smartindent nocindent
set iskeyword=@,48-57,_,192-255
