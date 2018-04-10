# loaded regardless of interactive

setopt BSD_ECHO
setopt UNSET
setopt SH_WORD_SPLIT
unsetopt BG_NICE
unsetopt HUP

export KERNEL=$(echo $(uname -o 2>/dev/null || uname -s) | tr / -)
export ARCH=`uname -m`
function platfile () {
	if test -r $HOME/.platform/arch-kernel/"$ARCH"-$KERNEL/$1
	then
		echo $HOME/.platform/arch-kernel/"$ARCH"-$KERNEL/$1
	fi
	if test -r $HOME/.platform/kernel/$KERNEL/$1
	then
		echo $HOME/.platform/kernel/$KERNEL/$1
	fi
	if test -r $HOME/.local/$1
	then
		echo $HOME/.local/$1
	fi
}

function pathlist () {
	platfile bin
	echo $HOME/bin
	echo /usr/local/bin
	echo /usr/local/sbin
	cat $(platfile pathBefore) </dev/null
	echo /usr/bin
	echo /bin
	echo /usr/sbin
	echo /sbin
	cat $(platfile pathAfter) </dev/null
}

function resetpath () {
	export PATH="$(pathlist | tr '\012' ':' | sed 's/^\(.*\):$/\1/')"
}

umask 022
if test -z "$systempath"
then
	systempath="$PATH"
	resetpath
fi

eval `$HOME/bin/agent -s`

# I hate color ls SO MUCH
export LS_COLORS='no=00:fi=00:rs=0:di=00:ln=00:mh=00:pi=00:so=00:do=00:bd=00:cd=00:or=40;31;01:su=00:sg=00:ca=00:tw=00:ow=00:st=00:ex=00'

export EDITOR='ddvim -f'
export PAGER=less
export RSYNC_RSH=ssh

unset TMOUT

# subject alt name for openssl
export SAN=''

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

NUGETEXE=`command -v nuget || command -v dotnet`
if echo "$NUGETEXE" | grep 'dotnet$' >/dev/null
then
	NUGETEXE="$NUGETEXE nuget"
fi

sourceExtra="`platfile zshenv`"
if test -r $HOME/.zshlocal
then
	sourceExtra="$sourceExtra $HOME/.zshlocal"
fi
for s in $sourceExtra
do
	. $s
done

