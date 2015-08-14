source ~/.vim/ftplugin/c.vim
set noexpandtab
set ts=8 sw=8
nmap   Q        O<ESC>iprintf("\n");<ESC>4hi
nmap   <C-W>    :w<ESC>:!chmod u+x %<ESC><C-L>
nmap   #        0i#<ESC>
nmap   @        :0i<CR>#!/usr/bin/awk -f<CR>.<CR>
