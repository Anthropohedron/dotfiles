set comments=:%%
imap  {       {}<ESC>i
imap  [       []<ESC>i
nmap  <C-W>   :w<CR>:make<CR>
if getline(1) =~ "^%parent: "
	let b:fname=fnamemodify(matchstr(getline(1), "[^ ^I]*", 9), ":r")
else
	let b:fname=expand("%:r")
endif
let $TEXTARGET=b:fname
let b:targetdir=fnamemodify(b:fname, ":h")
if filereadable(b:targetdir . "/Makefile")
	let &makeprg="make -C " . b:targetdir
elseif executable('pdflatex')
	let &makeprg="pdflatex $TEXTARGET"
else
	let &makeprg="latex $TEXTARGET"
endif
nmap   &r      :let &makeprg="latex $TEXTARGET && dvips -Ppdf -G0 $TEXTARGET -o"<CR>
nmap   &R      :let &makeprg="pdflatex $TEXTARGET"<CR>
nmap   @       0i%%<ESC>
nmap  <C-\>   :call ToggleNumbering()<CR>
inoremap <C-Q> <ESC>0Di\begin{}<CR>\end{}<ESC>Pk$Po
nnoremap Q 0Di\begin{}<CR>\end{}<ESC>Pk$Po
nmap   <C-\>    j$.O
nmap   \        i\<ESC>
nmap   <C-Down> :cn<ESC>
nmap   <C-Up>   :cp<ESC>
nmap   <C-K>    ^d%
nmap   <C-T>    {gq}
vmap   <C-T>    gq
nmap   ¬        <%
nmap   ®        >%
inoreabbr  eqn        \begin{eqnarray}<CR>\end{eqnarray}<ESC>O
inoreabbr  eqna       \begin{eqnarray*}<CR>\end{eqnarray*}<ESC>O
inoreabbr  itemi      \begin{itemize}<CR>\end{itemize}<ESC>O\item
inoreabbr  enum      \begin{enumerate}<CR>\end{enumerate}<ESC>O\item
iabbr  i          \item
inoreabbr  ii          i.e.\
inoreabbr  ee          e.g.\
