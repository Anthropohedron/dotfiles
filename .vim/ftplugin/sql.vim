let code_indent_is_reformat=0
source ~/.vim/ftplugin/code.vim
map @ 0i-- <ESC>
set iskeyword=@,48-57,_,192-255
set comments=:--
iabbr C CREATE
iabbr T TABLE
iabbr PK PRIMARY KEY
inoreabbr pk PRIMARY KEY ()<Left>
inoreabbr FK FOREIGN KEY()<Left>
iabbr V VIEW
iabbr I INDEX
iabbr D DATABASE
iabbr F FUNCTION
iabbr R REFERENCES
iabbr U UNIQUE
iabbr II INSERT INTO
inoreabbr v VALUES ();<Left><Left>
iabbr N NULL
iabbr NN NOT NULL
iabbr DN DEFAULT NULL
iabbr D DEFAULT
iabbr I INTEGER
iabbr T TEXT
iabbr TS TIMESTAMP
inoreabbr $ DECIMAL(5,2)
inoreabbr s VARCHAR(255)
inoremap ( ()<Left>
imap <Tab> <C-P>
