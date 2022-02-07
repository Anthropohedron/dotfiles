augroup filetype
au BufNewFile,BufRead TODO             	set ft=taskpaper
au BufNewFile,BufRead *tfrc,*.tf,tiny.*	set ft=tinyfugue
au BufNewFile,BufRead Makefile*		set ft=make
au BufNewFile,BufRead /tmp/mutt-*	set ft=mail
au BufNewFile,BufRead */ssh_config.d/*.conf	set ft=sshconfig
au BufNewFile,BufRead */.licq/*.conf	set ft=dosini
au BufNewFile,BufRead *.{h,c}		set ft=c
au BufNewFile,BufRead *.doxtxt		set ft=java
au BufNewFile,BufRead outline,*.outline	set ft=outline
au BufNewFile,BufRead *.mrg		set ft=sentence
au BufNewFile,BufRead *.plt		set ft=gnuplot
au BufNewFile,BufRead *.wml		set ft=html
au BufNewFile,BufRead *.tld		set ft=xml
au BufNewFile,BufRead *.pac		set ft=javascript
au BufNewFile,BufRead *.cls		set ft=tex
au BufNewFile,BufRead */.mutt/*		set ft=muttrc
au BufNewFile,BufRead *.md		set ft=markdown
au BufNewFile,BufRead */.sawfish/*	set ft=lisp
au BufNewFile,BufRead .tvtwmrc,*/.tvtwm/*		set ft=m4
au BufNewFile,BufRead .desksetdefaults	set ft=xdefaults
au BufNewFile,BufRead *.ad		set ft=xdefaults
au BufNewFile,BufRead .zwgc*		set ft=tcl
au BufNewFile,BufRead /tmp/cvs*		set ft=cvslog
"autocmd BufNewFile,BufRead *.rhtml	:set ft=eruby
autocmd BufNewFile,BufRead *.rxml	:set ft=ruby
augroup END
