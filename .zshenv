# loaded regardless of interactive

setopt BSD_ECHO
setopt UNSET
setopt SH_WORD_SPLIT
unsetopt BG_NICE
unsetopt HUP

_SHELL_BASICS="uname cat grep sed awk tr find xargs"

function _alias_basics () {
	local add_alias=$(test $# -gt 0 && echo true || echo false)
	for cmd in $_SHELL_BASICS
	do
		unalias "$cmd" 2>/dev/null
		$add_alias && alias "$cmd"="$(PATH=/bin:/usr/bin command -v "$cmd")"
	done
}

_alias_basics -a

export KERNEL=$(echo $(uname -o 2>/dev/null || uname -s) | tr / -)
export ARCH=$(uname -m)
PLATK="$HOME/.platform/kernel/$KERNEL"
PLATAK="$HOME/.platform/arch-kernel/$ARCH-$KERNEL"
PLATALL="$HOME/.platform/all"
PLATLOCAL="$HOME/.local"
PLATWSL=""
if test -r /proc/version && grep -i microsoft /proc/version >/dev/null
then
	PLATWSL="$HOME/.platform/wsl2"
fi

function platfile () {
	local LOCALFIRST=false
	if test x"$1" = x-l
	then
		shift
		LOCALFIRST=true
	fi
	if $LOCALFIRST && test -r "$PLATLOCAL"/$1
	then
		echo "$PLATLOCAL"/$1
	fi
	if test -r "$PLATALL"/$1
	then
		echo "$PLATALL"/$1
	fi
	if test -n "$PLATWSL" -a -r "$PLATWSL"/$1
	then
		echo "$PLATWSL"/$1
	fi
	if test -r "$PLATAK"/$1
	then
		echo "$PLATAK"/$1
	fi
	if test -r "$PLATK"/$1
	then
		echo "$PLATK"/$1
	fi
	if ! $LOCALFIRST && test -r "$PLATLOCAL"/$1
	then
		echo "$PLATLOCAL"/$1
	fi
}

function _BasePath () {
	cat $(platfile pathPrepend) </dev/null
	platfile bin
	echo "$HOME"/bin
	echo /usr/local/bin
	echo /usr/local/sbin
	echo "$HOME"/.yarn/bin
	cat $(platfile pathBefore) </dev/null
	echo /usr/bin
	echo /bin
	echo /usr/sbin
	echo /sbin
	cat $(platfile pathAfter) </dev/null
}

function _CondPath () {
	platfile ifcommand |\
		xargs -I X find X -maxdepth 1 -mindepth 1 -type d |\
		awk -F / '{
			count = split($NF, cmds, "@");
			for (i=1; i<=count; ++i) {
				printf("command -v %s >/dev/null && ", cmds[i]);
			}
			printf("echo %s\n", $0)
		}' |\
		/bin/sh
}

function _JoinPath () {
	tr '\012' ':' | sed \
		-e 's,~,'"$HOME",g \
		-e 's/::\+//g' \
		-e 's/:$//'
}

function resetpath () {
	PATH="$(_BasePath | _JoinPath)"
	export PATH
	local base_path="$PATH"
	local prev_path_items=""
	local more_path_items="$(_CondPath | _JoinPath)"
	while test "$prev_path_items" != "$more_path_items"
	do
		prev_path_items="$more_path_items"
		PATH="$base_path":"$more_path_items"
		export PATH
		more_path_items="$(_CondPath | _JoinPath)"
	done
}

function isZshArray () {
	declare -p "$1" 2>/dev/null |\
		sed -n 's/^\(typeset\|declare\) *.* -a .*'"$1"'=(.*$/YES/p' |\
		grep -q '^YES$'
}

umask 022
if test -z "$systempath"
then
	systempath="$PATH"
	resetpath
fi

_alias_basics

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
		elif test "$TERM" = xterm -o \
			"$TERM" = xterm-256color
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

NUGETEXE=`whence -p nuget || whence -p dotnet`

NEED_GEOMETRY=false
if test -n "$DISPLAY" && xdpyinfo | grep -q Apple-WM
then
	NEED_GEOMETRY=true
fi

for s in $(platfile zshenv)
do
	. $s
done

