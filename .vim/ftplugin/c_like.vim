source ~/.vim/ftplugin/code.vim
inoreabbr else } else{<Left>
inoreabbr elsee else
set noai
set cindent
set comments=sr:/*,mb:*,el:*/,sr:/**,mb:*,el:*/,:///,://
imap   {        {<CR>}<ESC>O
nmap   <C-V>    O<ESC>i/*<ESC>jo<ESC>i*/<ESC>
nnoremap d;     dt;
nmap   ;        a;<ESC>
nmap   _        hea_<ESC>
nmap   @        I//<ESC>
