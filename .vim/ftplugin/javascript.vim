source ~/.vim/ftplugin/c_like.vim
set smartindent
set sw=4 ts=4
inoreabbr  try      try {<CR>} catch (ex) { }<ESC>O<Left>
inoreabbr  finally  } finally {<CR><Del>
"nmap!  <C-P>    3.1415927
"nmap!  <C-R>    1.5707963
nmap   <C-W>    :wnext<CR>
nmap   Q        O<ESC>ialert("");<ESC>hhi
