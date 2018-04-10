# only for interactive shells

if test -z "$systemfpath"
then
	systemfpath="$fpath"
fi
homefpath=($HOME/.zsh/functions `platfile functions`)
fpath=($homefpath $systemfpath)
autoload -U ${^homefpath}/*(:t)
autoload -U compinit
compinit

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

setopt AUTO_CD
setopt CHASE_LINKS
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

setopt ALWAYS_TO_END
setopt AUTO_LIST
setopt AUTO_MENU
setopt REC_EXACT
setopt AUTO_PARAM_KEYS
setopt AUTO_PARAM_SLASH
setopt AUTO_REMOVE_SLASH
setopt COMPLETE_ALIASES
setopt GLOB_COMPLETE
setopt LIST_AMBIGUOUS
setopt LIST_TYPES

setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_FCNTL_LOCK
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_NO_STORE
setopt HIST_REDUCE_BLANKS

setopt CORRECT
setopt PRINT_EXIT_VALUE

setopt AUTO_CONTINUE
#setopt MONITOR
setopt NOTIFY

setopt PROMPT_PERCENT
setopt PROMPT_SUBST

export CDPATH=.:~

export HISTFILE=~/.zsh_history
export SAVEHIST=500
export HISTSIZE=500

alias ..='cd ..'
alias cd..='cd ..'
alias edtr=ddvim
alias pd=pushd
alias pop=popd

export cppipe=$HOME/.pipes/cppipe
if test ! -p $cppipe
then
	mknod $cppipe p || mkfifo $cppipe
	chmod 600 $cppipe
fi

cdpipe=$HOME/.pipes/cdpipe
if test ! -p $cdpipe
then
	mknod $cdpipe p || mkfifo $cdpipe
	chmod 600 $cdpipe
fi
alias cdl='cd "`cat $cdpipe`"'
alias pdl='pd "`cat $cdpipe`"'
alias cdlf='cd "`xargs -0 dirname < $cdpipe`"'
alias pdlf='pd "`xargs -0 dirname < $cdpipe`"'
alias lcd='pwd > $cdpipe'

alias w='whence -c'
alias whichall='whence -c -a'
alias m="$PAGER"

function msh () {
	case `whence -w $1 | cut -d\  -f2` in
		none)
			echo "$1": Not found
			;;
		alias|builtin|function|hashed|reserved)
			whence -c $1
			;;
		command)
			local cmd=`whence -p $1`
			local filetype="`file -Lb $cmd`"
			if expr "$filetype" : '.*script.*' >/dev/null
			then
				$PAGER `whence -p $1`
			else
				echo "$cmd": "$filetype"
			fi
			;;
	esac
}
function edsh () {
	case `whence -w $1 | cut -d\  -f2` in
		none)
			echo "$1": Not found
			;;
		alias|builtin|hashed|reserved)
			whence -c $1
			;;
		function)
			ll
			;;
		command)
			local cmd=`whence -p $1`
			local filetype="`file -Lb $cmd`"
			if expr "$filetype" : '.*script.*' >/dev/null
			then
				edtr `whence -p $1`
			else
				echo "$cmd": "$filetype"
			fi
			;;
	esac
}
function mz () {
	zcat $1 | $PAGER
}

alias gvw='gv -watch -swap'

alias vi=ddvim
alias rm='rm -i'
alias ls='ls -F'
alias dir='ls -l'
function dls () {
	ls -F1 "$@" | grep /\$ | pr -3 -t
}

function l () {
	grep "$@" ~/.z{shenv,shrc,login}
}
alias ll="edtr ~/.zshrc"
alias lll=". ~/.zshenv; . ~/.zshrc"
alias edenv="edtr ~/.zshenv"
alias edssh="edtr ~/.ssh/config"
alias edk="edtr ~/.ssh/known_hosts"

alias elm=mutt
if test -d $HOME/Maildir
then
	alias spsp='spamlearn -s --showdots && spamlearn -h --showdots'
	alias esp='mutt -f $HOME/Maildir/.spam'
	alias egm='mutt -f imaps://imap.gmail.com/'
fi
if test -f $HOME/.elm/aliases.text
then
	function a () {
		grep -i "$@" $HOME/.elm/aliases.text
	}
	function wh () {
		a "$@" | cut -d= -f1 | xargs checkalias
	}
	function edmail () {
		$EDITOR +"source $HOME/.vim/mail.vim|set nospell"\
			$HOME/.elm/aliases.text
		newalias
		elm2mutt > $HOME/.mutt/aliases
	}
fi
if test -r $HOME/.mutt/subs.m4
then
	function edsubs () {
		$EDITOR $HOME/.mutt/subs.m4
	}
fi

alias mvno="mvn -o -DskipTests"
function pg () {
	ps -efaww | grep "$@"
}

function svnst () {
	svn status --ignore-externals "$@"
}
function svm () {
	svnst "$@" | grep '^[AM]' | cut -c9-
}
function svi () {
	ddvim -p `svm "$@"`
}
function svjs () {
	svm "$@" | grep '\.js$'
}
function svji () {
	ddvim -p `svjs "$@"`
}
function svl () {
	svjs "$@" | xargs jslint
}

alias gita="git add --all"
alias gst="git status"
alias gitst="git status --porcelain"
function gitm () {
	gitst "$@" | grep '^\s\?[?AM]' | cut -c4-
}
function gvi () {
	ddvim -p `gitm "$@"`
}
function gitjs () {
	gitm "$@" | grep '\.js$'
}
function gjl () {
	gitjs "$@" | xargs jslint
}
function gtc () {
	local branch="$(git cur)"
	if test $? -eq 0 -a $# -ge 0
	then
		if expr "$branch" : '^[-a-zA-Z0-9]\+/[A-Z]\+-[0-9]\+$' >/dev/null
		then
			git commit -m "$(echo $branch | cut -d/ -f2): $*"
		else
			git commit -m "$*"
		fi
	else
		git status
		false
	fi
}

alias master="git checkout master"
alias ggg="git checkout"
alias gg-="git checkout -"
alias gg..="git checkout -"
alias gdc="git diff"
alias gdf="git diff --name-only"
alias gds="git diff --stat"
function gthisweek () {
	gdc 'HEAD@{'`date +%w`' days ago}' HEAD -- "$@"
}
function glastweek () {
	local daysSinceSunday=`date +%w`
	local prevSunday=`expr 7 + $daysSinceSunday`
	gdc 'HEAD@{'$prevSunday' days ago}' 'HEAD@{'$daysSinceSunday' days ago}' -- "$@"
}

function pv () {
	eval `rails_appdirs app/helpers,app/views "$@"`
}
function pc () {
	eval `rails_appdirs app/models,app/controllers "$@"`
}
function pt () {
	eval `rails_appdirs test/functional,test/fixtures,test/unit "$@"`
}
function pa () {
	eval `rails_appdirs public/stylesheets,public/javascripts "$@"`
}

function vir () {
	ddvim -p `find . -name '.*.swp' | sed 's,/\.\([^/]*\)\.swp$,/\1,'`
}

alias stamp='date -u +%Y-%m-%d_%H:%M:%S'

alias google='w3m http://www.google.com/'
function mani () {
	info --subnodes --output - "$1" | $PAGER
}
function myip () {
	ifconfig | grep '\<inet\>' |\
		tr '\011' ' ' | tr -dc '[0-9]. \012' |\
		sed	-e '/^ *127\./d' \
			-e 's/^ *//' \
			-e 's/ .*$//'
}

if test -n "$DISPLAY"
then
	if test -z "$DISPLAY_ORIG"
	then
		DISPLAY_ORIG="$DISPLAY"
		DISPLAY=$(echo $DISPLAY | sed 's,^.*/com\.apple\.launchd[^:]*:,:,')
		export DISPLAY
	fi
	function mkxsu () {
		unfunction mkxsu
		if command -v zshsulogin >/dev/null
		then
			alias xsu="(xterm -T root@$HOST -e `zshsulogin DISPLAY=$DISPLAY XAUTHORITY=$HOME/.Xauthority` &)"
		else
			alias xsu="echo Error: Define zshsulogin for this platform"
		fi
	}
	alias xcr='(xterm -geometry 80x55 -bg black -fg white -e "screen -D -R" &)'
	alias ibg='ppmmake gray 50 50 > /tmp/g$$.ppm; xsetbg -onroot /tmp/g$$.ppm; rm -f /tmp/g$$.ppm'
	alias vnc='vncviewer -PreferredEncoding ZRLE -LowColourLevel 2 -MenuKey F9'
	MAILFOLDERS=($HOME/Maildir $HOME/Maildir/.alerts $HOME/Maildir/.lists)
	if test -d ${(pj: -a -d :)MAILFOLDERS[@]}
	then
		COOLARGS="-once \
			 ${(ps: :)MAILFOLDERS[@]:s/\//-f \//} \
			-e mailterm"
		if test -x /usr/bin/kstart &&
			xlsatoms -name _KDE_NET_SYSTEM_TRAY_WINDOWS 2>&1 | \
				grep '^[0-9]' >/dev/null 2>&1
		then
			alias osxbiff="kstart --window coolmail --tosystray coolmail -geometry 55x55-0+21 $COOLARGS </dev/null >/dev/null 2>&1"
		else
			alias osxbiff="(coolmail -geometry 55x55+0-0 $COOLARGS </dev/null >/dev/null 2>&1 &)"
		fi
	fi
	if command -v xdotool xdpyinfo >/dev/null && \
		xdpyinfo | grep '\<XTEST\>' >/dev/null 2>&1
	then
		alias fosxbiff="xdotool search --name coolmail windowmove 0 970"
	fi
	if command -v xprop >/dev/null
	then
		function xsetprop () {
			local _prop=$1
			local _type=$2
			local _value="$3"
			shift 3
			xprop "$@" -f $_prop $_type -set $_prop "$_value"
		}
	fi
else
	function mkxsu () {
		unfunction mkxsu
		if command -v zshsulogin >/dev/null
		then
			alias xsu="`zshsulogin zsh -l`"
		else
			alias xsu="echo Error: Define zshsulogin for this platform"
		fi
	}
fi

function fjs () {
	fpath="${1:-"."}"
	if test $# -gt 0
	then
		shift
	fi
	find "$fpath" \
		-path './css'     -prune \
		-path './docs'    -prune \
		-path './extjs'   -prune \
		-path './ext'     -prune \
		-path './images'  -prune \
		-path './WEB_INF' -prune \
		-o -name '*.js' "$@"
}
function fcs () {
	fpath="${1:-"."}"
	if test $# -gt 0
	then
		shift
	fi
	find "$fpath" \
		-name '*.cs' "$@"
}
function cloc () {
	fjs "$@" |\
		xargs ~/bin/cloc.pl --sql 1 --sql-project code |\
		sqlite3 code.db
}
alias clocsum="sqlite3 code.db 'select num(nCode) from t;'"
alias cloctop="sqlite3 code.db 'select File, nCode from t order by nCode DESC limit 10;'"
function gjs () {
	fjs . -print0 | xargs -0 grep "$@"
}
function gcs () {
	fcs . -print0 | xargs -0 grep "$@"
}

function wiki () {
	dig +short txt "$1".wp.dg.cx | fmt
}
alias bt=transmissioncli

prompt="%m %~ %B%#%b "
if test -n "$xprompt"
then
	if test "$xprompt" = title
	then
		TITLEHOST=$SHOST
		function chpwd () {
			local dirs="`dirs`"
			prompt="%m ${dirs} %B%#%b "
			print -nP '\033]0;%m: %~\007'
		}
	else
		TITLEHOST=$SHOST
		function chpwd () {
			local dirs="`dirs`"
			prompt="%m ${dirs} %B%#%b "
		}
	fi
	chpwd
else
	function chpwd () { }
fi

function foreground-process () {
	fg 2>/dev/null || echo "fg: No current job"
}
zle -N foreground-process

function list-jobs () {
	echo ''
	jobs
	zle redisplay
}
zle -N list-jobs

bindkey -e
bindkey '\E\C-Z' foreground-process
bindkey '\C-F'   forward-word
bindkey '\C-B'   backward-word
bindkey '\C-R'   redisplay
bindkey '\E*'    expand-glob
bindkey '\Eg'    list-glob
bindkey '\EG'    list-glob
bindkey '\C-W'   backward-kill-word

bindkey '\EOB'   history-beginning-search-forward
bindkey '\EOA'   history-beginning-search-backward
bindkey '\E[B'   history-beginning-search-forward
bindkey '\E[A'   history-beginning-search-backward
bindkey '\E[H'   beginning-of-line
bindkey '\E[F'   end-of-line
bindkey '\E[1~'  beginning-of-line
bindkey '\E[4~'  end-of-line

#WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
WORDCHARS=\'\"'[]{}()<>^$%~_.'

sourceExtra="`platfile zshrc`"
for s in $sourceExtra
do
	. $s
done

if test -n "$FFPASS" && command -v nss-passwords >/dev/null
then
	alias ffpass="nss-passwords -d $FFPASS"
fi

mkxsu
