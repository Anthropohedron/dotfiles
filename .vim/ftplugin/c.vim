source ~/.vim/ftplugin/c_like.vim
set makeprg=gmake\ %:r.o
set errorformat=%*[^\"]\"%f\"%*[^0-9]%l:\ %m,\"%f\"%*[^0-9]%l:\ %m,%f:%l:%m,\"%f\"\\,\ line\ %l%*[^0-9]%c%*[^\ ]\ %m
"set errorformat=%*[^"]"%f"%*[^0-9]%l: %m,"%f"%*[^0-9]%l: %m,%f:%l:%m,"%f"\, line %l%*[^0-9]%c%*[^ ] %m
let @g="#if 0\n v" . "im:ft=c\n#endif\n"
iabbr inc #include ""<Left>
iabbr Inc #include <><Left>
inoreabbr main  int<CR>main(int argc, char **argv) {<CR>}<ESC>O<Left>
nmap   Q        O<ESC>i#ifndef NDEBUG<CR>fprintf(stderr, "\n");<CR>#endif<ESC>k$hhhhi
nmap   <C-W>    :w<CR>:make<CR>
nmap   @        O#if 0<ESC>jo#endif<ESC>
nmap   \        :source ~/.vim/ctmpl.vim<CR><C-L>
" vim: ft=vim
