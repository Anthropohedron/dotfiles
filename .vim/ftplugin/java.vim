source ~/.vim/ftplugin/c_like.vim
set makeprg=ant\ -Dsourcefile=%\ compile\ -find
inoreabbr  try      try {<CR>} catch (Exception ex) { }<ESC>O<Left>
inoreabbr finally } finally {<CR><Del>
iabbr  cin      System.in.println("");<ESC>2hi
iabbr  cout     System.out.println("");<ESC>2hi
iabbr  cerr     System.err.println("");<ESC>2hi
inoreabbr main  public static void main(String args[]) {<CR>}<ESC>O<Left>
let @g="/*\n v" . "im:ft=java\n */"
nmap   \       :$put g<CR><C-L>
nmap   Q        O<ESC>iSystem.err.println("");<ESC>hhi
nmap   &1       :set makeprg=javac\ %<CR><C-L>
nmap   &2       :set makeprg=javac\ -target\ 1.1\ %<CR><C-L>
nmap   &R       :set makeprg=ant\ -Dsourcefile=%\ compile\ -find<CR><C-L>
"nmap!  <C-P>       Math.PI
"nmap!  <C-R>       Math.PI*.5
