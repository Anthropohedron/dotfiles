#!/bin/sh

#exec >/dev/ttys000
#exec 2>&1
#set -x

for XINIT in /usr/X11/lib/X11/xinit \
	/opt/local/etc/X11/xinit \
	/no/such/path
do
	test -d "$XINIT" && break
done

localresources=$HOME/.local/Xresources
localmodmap=$HOME/.local/Xmodmap
userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=$XINIT/.Xresources
sysmodmap=$XINIT/.Xmodmap

cd $HOME
PATH="`zsh -c 'echo $PATH'`"
export PATH
DISPLAY=`echo $DISPLAY | sed 's,^.*/:,:,'`
export DISPLAY
#eval `dbus-launch --sh-syntax`

xset fp+ $HOME/Library/Fonts/

# merge in defaults and keymaps

if [ -f "$sysresources" ]; then
    xrdb -merge "$sysresources"
fi

if [ -f "$sysmodmap" ]; then
    xmodmap "$sysmodmap"
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [ -f "$localresources" ]; then
    xrdb -merge "$localresources"
fi

if [ -f "$localmodmap" ]; then
    xmodmap "$localmodmap"
fi

#tcsh -c 'growling_pidgin.py &'

#USERWM=/opt/local/bin/openbox

# start some nice programs

if [ -d $HOME/xinitrc.d ] ; then
	for f in $HOME/xinitrc.d/*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

if [ -d $XINIT/xinitrc.d ] ; then
	for f in $XINIT/xinitrc.d/*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# start the window manager
#exec quartz-wm

