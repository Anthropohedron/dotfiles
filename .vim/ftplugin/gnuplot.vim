set makeprg=gnuplot\ %
set comments=n:#
nmap  &r      :set makeprg=gnuplot\ %;gv\ %:r.eps<CR>
nmap  <C-W>   :w<CR>:make<CR>
nmap  #       0i#<ESC>
nmap  @       :0i<CR>set terminal postscript eps color solid 18<CR>.<CR>
nmap  <Tab>   >>
vmap  <Tab>   >
nmap  <C-\>   :call ToggleNumbering()<CR>
iabbr  s          set
iabbr  sp         splot
iabbr  p          plot

