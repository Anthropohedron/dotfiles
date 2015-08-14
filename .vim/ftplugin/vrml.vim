"set makeprg=java\ trapezium.vorlon\ %\ \\\|\ java\ VorlonFilter
set makeprg=java\ VorlonFilter\ %
set errorformat=%f(%l):\ %m
iabbr  EX      EXTERNPROTO
iabbr  PR      PROTO
iabbr  Nav     NavigationInfo { type [ "EXAMINE", "ANY" ] }
iabbr  App     Appearance { material Material {<CR>		diffuseColor
imap  <C-P>    3.1415927
imap  <C-R>    1.5707963
nmap   <C-W>   :w<ESC>:make<ESC>
nmap   <C-P>   :r !protoref 
nmap   #       0i#<ESC>
nmap   @       1GO#VRML V2.0 utf8<ESC>
nmap   ;       a;<ESC>
nmap   d;      dt;
nmap   =       s = <ESC>
nmap   (       lbi(<ESC>
nmap   )       hea)<ESC>
nmap   <Tab>   >>
vmap   <Tab>   >
nmap   <C-K>   ^d%
nmap   ¬       <%
nmap   ®       >%
