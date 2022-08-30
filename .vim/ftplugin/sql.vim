let code_indent_is_reformat=0
source ~/.vim/ftplugin/code.vim
map @ 0i-- <ESC>
set iskeyword=@,48-57,_,192-255
set comments=:--
iabbr C CREATE
iabbr T TABLE
iabbr V VIEW
iabbr I INDEX
iabbr D DATABASE
iabbr F FUNCTION
iabbr R REFERENCES
iabbr U UNIQUE
iabbr II INSERT INTO
inoreabbr v VALUES ();<Left><Left>
iabbr n null
iabbr nn not null
iabbr dn default null
iabbr d default
iabbr i integer
iabbr t text
iabbr ts timestamp
inoreabbr pk primary key ()<Left>
inoreabbr $ decimal(5,2)
inoreabbr s varchar(255)
inoremap ( ()<Left>
imap <Tab> <C-P>
