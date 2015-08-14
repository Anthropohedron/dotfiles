source ~/.vim/ftplugin/c_like.vim
set matchpairs=(:),{:},[:],<:>,-:>
let @g="#if 0\n v" . "im:ft=objc\n#endif\n"
iabbr imp #import ""<Left>
iabbr Imp #import <><Left>
inoreabbr  try      @try {<CR>} @catch (Exception &ex) { }<ESC>O<Left>
nmap   Q        O<ESC>i#ifndef NDEBUG<CR>std::cerr <<  << std::endl;<CR>#endif<ESC>k$BBhi
nmap   @        I//<ESC>
" vim: ft=vim
