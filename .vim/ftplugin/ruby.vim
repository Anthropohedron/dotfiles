nmap   Q       OSTDERR.puts ""<ESC>hi
nmap   @       :0i<CR>#!/usr/bin/env ruby<CR>.<CR>
nmap   <C-W>   :w<CR>:!chmod u+x %<CR><C-L>
nmap   #       :set paste<CR>0i#<ESC>:set nopaste<CR><C-L>
nmap   <Tab>   >>
vmap   <Tab>   >
nmap   <C-K>   ^d%
nmap   ¬       <%
nmap   ®       >%
set expandtab ts=2 sw=2
set indentkeys+=#
set noai smartindent nocindent
set iskeyword=@,48-57,_,192-255
