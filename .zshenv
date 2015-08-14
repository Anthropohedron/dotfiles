# loaded regardless of interactive

setopt BSD_ECHO
setopt UNSET
setopt SH_WORD_SPLIT
unsetopt BG_NICE
unsetopt HUP

umask 022
if test -z "$systempath"
then
	systempath="$PATH"
	export PATH=$HOME/bin:/usr/local/bin:/usr/local/sbin:/opt/local/bin:/opt/local/sbin:/usr/X11R6/bin:/usr/bin:/bin:/usr/sbin:/sbin
fi

eval `$HOME/bin/agent -s`

# I hate color ls SO MUCH
export LS_COLORS='no=00:fi=00:rs=0:di=00:ln=00:mh=00:pi=00:so=00:do=00:bd=00:cd=00:or=40;31;01:su=00:sg=00:ca=00:tw=00:ow=00:st=00:ex=00'

export EDITOR='ddvim -f'
export PAGER=less
export RSYNC_RSH=ssh

unset TMOUT

export KERNEL=`uname -s`
export ARCH=`uname -m`

function platfile () {
	if test -r $HOME/.platform/kernel/$KERNEL/$1
	then
		echo $HOME/.platform/kernel/$KERNEL/$1
	fi
	if test -r $HOME/.platform/arch-kernel/"$ARCH"-$KERNEL/$1
	then
		echo $HOME/.platform/arch-kernel/"$ARCH"-$KERNEL/$1
	fi
}

if test -n "$TERM"
then
	if test -z "$xprompt"
	then
		if test "$TERM" = screen
		then
			xprompt=title
			export TERM=xterm
		elif test "$TERM" = xterm
		then
			xprompt=title
		else
			xprompt=prompt
		fi
	fi
fi

test -r "$HOME/.rninit"      && export TRNINIT="$HOME/.rninit"
test -d "$HOME/tex/packages" && export TEXINPUTS=".:$HOME/tex/packages:"
test -d "$HOME/lib/classes"  && export JAVA_CLASSDIR="$HOME/lib/classes"
test -d "/home/cvsroot"      && export CVSROOT=/home/cvsroot

if test -f "$HOME/.terminfo/$TERM[1]/$TERM"
then
	export TERMINFO="$HOME/.terminfo"
	export TERM=$TERM
fi

export ENSCRIPT="-1BglR -M letter -fCourier11"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LESSCHARSET=utf-8
export LESS='-m -E -F -X'
export CVS_RSH=ssh
export RSYNC_RSH=ssh

sourceExtra="`platfile zshenv`"
if test -r $HOME/.zshlocal
then
	sourceExtra="$sourceExtra $HOME/.zshlocal"
fi
for s in $sourceExtra
do
	. $s
done

