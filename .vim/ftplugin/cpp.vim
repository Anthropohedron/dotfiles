source ~/.vim/ftplugin/c.vim
set matchpairs=(:),{:},[:],<:>,-:>
let @g="#if 0\n v" . "im:ft=cpp\n#endif\n"
set errorformat=%*[^\"]\"%f\"%*\\D%l:\ %m,\"%f\"%*\\D%l:\ %m,%-G%f:%l:\ (Each\ undeclared\ identifier\ is\ reported\ only\ once,%-G%f:%l:\ for\ each\ function\ it\ appears\ in.),%f:%l:%m,\"%f\"\\,\ line\ %l%*\\D%c%*[^\ ]\ %m,%D%*\\a[%*\\d]:\ Entering\ directory\ `%f',%X%*\\a[%*\\d]:\ Leaving\ directory\ `%f',%DMaking\ %*\\a\ in\ %f
inoreabbr  try      try {<CR>} catch (const exceptions::Exception &ex) { }<ESC>O<Left>
inoreabbr  unstd    using namespace std
nmap  Q        O<ESC>i#ifndef NDEBUG<CR>std::cerr <<  << std::endl;<CR>#endif<ESC>k$BBhi
nmap  @        I//<ESC>
" vim: ft=vim
