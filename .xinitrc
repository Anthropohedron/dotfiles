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

cd $HOME
PATH="`zsh -c 'echo $PATH'`"
export PATH
DISPLAY=`echo $DISPLAY | sed 's,^.*/:,:,'`
export DISPLAY
#eval `dbus-launch --sh-syntax`

xset fp+ $HOME/Library/Fonts/

# merge in defaults and keymaps

PREFIXES="\
	$XINIT/. \
	$HOME/. \
	$(sed -E 's,/?$,/,' $HOME/.local/PLATK 2>/dev/null) \
	$(sed -E 's,/?$,/,' $HOME/.local/PLATAK 2>/dev/null) \
	$HOME/.local/ \
	"

for p in $PREFIXES
do
	if test -r "$p"XResources
	then
		xrdb -merge "$p"XResources
	fi
	if test -r "$p"Xmodmap
	then
		xmodmap "$p"Xmodmap
	fi
done

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

