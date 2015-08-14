source ~/.vim/ftplugin/html.vim
source ~/.vim/ftplugin/c.vim
set sw=3 ts=3
let @g=""
unab inc
unab Inc
nmap Q O<ESC>i%><!--  --><%<ESC>Bhi
unmap _
unmap &r
unmap &w
nmap   `        F"i
nnoremap   @        :set paste<CR>O<li></li><ESC>:set nopaste<CR>4hi
nmap   <C-\>        :set paste<CR>1GO<%@ page %><CR><html><head><CR><title></title><CR></head><body><CR><h1 style="text-align:center"></h1><ESC>:set nopaste<CR>3Gf<i
nmap   \        /center"><\/h<CR>f<.o<CR></body></html><ESC>
inoreabbr  try      try {<CR>} catch (Exception ex) { }<ESC>O<Left>
nmap   <C-W>    :w<ESC>
nmap   <C-V>    O<ESC>i<%--<ESC>jo<ESC>i--%><ESC>
imap  {         { %><CR><C-D><% }<ESC>O
