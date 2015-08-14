"""""is this necessary?
autocmd!
"set verbose=9

" vim -b : edit binary using xxd-format!
augroup Binary
  au!
  au BufReadPre  *.bin let &bin=1
  au BufReadPost *.bin if &bin | %!xxd
  au BufReadPost *.bin set ft=xxd | endif
  au BufWritePre *.bin if &bin | %!xxd -r
  au BufWritePre *.bin endif
  au BufWritePost *.bin if &bin | %!xxd
  au BufWritePost *.bin set nomod | endif
augroup END
"""""questionable triggers, but hasn't hurt so far
"autocmd BufLeave * :source ~/.vim/leave.vim
autocmd BufEnter *.tex :let $TEXTARGET=b:fname
autocmd BufEnter * :source ~/.vim/controlsyntax.vim | source ~/.vim/incpath.vim
autocmd VimEnter * :call OpenInc(expand("%:r"), expand("%:e"))
"""""triggers to toggle backup
autocmd BufEnter */.xblast-setups/* :set nobackup
autocmd BufLeave */.xblast-setups/* :set backup
autocmd BufEnter */.postitnotes/* :set nobackup
autocmd BufLeave */.postitnotes/* :set backup
autocmd BufEnter *.mp3 :set nobackup
autocmd BufLeave *.mp3 :set backup
autocmd BufEnter */tmp/* :set nobackup
autocmd BufLeave */tmp/* :set backup
autocmd BufEnter */tt/* :set nobackup
autocmd BufLeave */tt/* :set backup
"""""generate a java stub class file
autocmd BufNewFile *.java :read !$HOME/bin/dev/newjava %:p
"""""generate a LaTeX article template
autocmd BufNewFile *.tex :source ~/.vim/textmpl.vim
"""""questionably filetype triggers
autocmd BufWrite */tmp/zreply-* :source ~/.vim/zreplymail.vim
autocmd BufRead  */tmp/mutt-* :source ~/.vim/muttmail.vim
autocmd BufRead  */tmp/mozex.textarea.* :source ~/.vim/mozex.vim
autocmd BufRead  */itsalltext/* :source ~/.vim/mozex.vim
autocmd BufEnter .*rc :source ~/.vim/ftplugin/sh.vim
"""""definitely filetype triggers
autocmd FileType mail :source ~/.vim/mail.vim
"set verbose=0
