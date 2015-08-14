set ft=html tw=0 wrap linebreak
"vmap R :'<,'>call HTMLHilightLines("ruby")
vmap R :'<,'>!highlight "ruby"
