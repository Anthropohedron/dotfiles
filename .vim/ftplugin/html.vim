if &ft == "markdown"
	finish
endif
source ~/.vim/ftplugin/xml.vim
iunmap  <Tab>
nmap   `        F"i
nnoremap   @        O<l<ESC>ai></l<ESC>ai><ESC>4hi
nnoremap   #        O<l<ESC>ai><<ESC>aa href=""></a></l<ESC>ai><ESC>8hi
vnoremap   <C-A>        xa<a href=""<ESC>lp
if &ft == "xhtml"
	nmap   <C-\>  :set paste<CR>1GO<?xml version="1.0" encoding="utf-8" ?><CR><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"<CR> "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><CR><html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en"><head><CR><title></title><CR></head><body><CR><h1 style="text-align: center;"></h1><ESC>:set nopaste<CR><C-L>5Gf<i
else
	nmap   <C-\>  :set paste<CR>1GO<!DOCTYPE html><CR><html><head><CR><title></title><CR></head><body><CR><h1 style="text-align:center"></h1><ESC>:set nopaste<CR><C-L>3Gf<i
endif
nmap   \        /"><\/h<CR>f<.o<CR></body></html><ESC>
nmap   <C-Y>    {gq}
nnoremap   &r   :source $HOME/.vim/reload.vim<CR><C-L>
nnoremap   &w   :source $HOME/.vim/html.vim<CR><C-L>
iabbr      ol   ol<CR></ol><ESC>kA
iabbr      ul   ul<CR></ul><ESC>kA
iabbr      h1   h1</h1><ESC>4hi
iabbr      h2   h2</h2><ESC>4hi
iabbr      h3   h3</h3><ESC>4hi
iabbr      h4   h4</h4><ESC>4hi
iabbr      h5   h5</h5><ESC>4hi
iabbr      h6   h6</h6><ESC>4hi
iabbr      li   li</li><ESC>4hi
iabbr      <a   <a></a><ESC>4hi
iabbr      <i   <i</i><ESC>3hi
iabbr      <b   <b</b><ESC>3hi
