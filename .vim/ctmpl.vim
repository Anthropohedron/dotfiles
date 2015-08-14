if expand("%:t:e:s/[hH].*$//")==""
	source $HOME/.vim/hdrtmpl.vim
else
	source $HOME/.vim/srctmpl.vim
endif
