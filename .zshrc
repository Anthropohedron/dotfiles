# only for interactive shells

# begin completion

if test -z "$systemfpath"
then
	systemfpath="$fpath"
fi
homefpath=($HOME/.zsh/functions `platfile functions`)
fpath=($homefpath $systemfpath)
autoload -U ${^homefpath}/*(:t)
autoload -U compinit && compinit
autoload -U colors && colors

if test ! -r ~/.zplug/init.zsh
then
	git -C ~ submodule init
	git -C ~ submodule update
fi

if test -r ~/.zplug/init.zsh && \
	! command -v zplug >/dev/null
then
	source ~/.zplug/init.zsh

	zplug "zsh-users/zsh-syntax-highlighting", defer:2
	zplug "zsh-users/zsh-autosuggestions"

	if ! zplug check
	then
	    zplug install
	fi
	zplug load
fi

zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# end completion
# begin options

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
#setopt COMPLETE_ALIASES
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

ORIG_HISTFILE=~/.zsh_history
export HISTFILE=$ORIG_HISTFILE
export SAVEHIST=500
export HISTSIZE=500

#end options

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
if test ! -d "$HOME/.local"
then
	mkdir "$HOME/.local"
fi
if test ! -r "$HOME/.local/promptdirs.sed"
then
	echo 's,^'"$HOME"',~,' > "$HOME/.local/promptdirs.sed"
fi


# begin aliases

alias cdl='cd "`cat $cdpipe`"'
alias pdl='pd "`cat $cdpipe`"'
alias cdlf='cd "`xargs -0 dirname < $cdpipe`"'
alias pdlf='pd "`xargs -0 dirname < $cdpipe`"'
alias lcd='pwd > $cdpipe'

dirstacks="$HOME/.dirstacks/"
alias lsds='find "$dirstacks" -name '"'stack*'"' | sort -r'
alias catdirstack='for d in "${(@)dirstack}"; do echo "$d"; done'
function writewd () {
	pwd
	catdirstack
}
function sroll () {
	awk -v count=${1:-"1"} '
		NR <= count {lines[NR] = $0}
		NR > count {print}
		END {for (i=1;i<=count;++i) print lines[i]}'
}
if test $(whence -w rd | cut -d\  -f2) = alias
then
	unalias rd
fi
function rd () {
	local oldIFS="$IFS"
	IFS=$'\n'
	dirstack=($(catdirstack | sroll "$@"))
	IFS="$oldIFS"
}
function readwd () {
	local oldIFS="$IFS"
	IFS=$'\n'
	dirstack=($(cat))
	IFS="$oldIFS"
	popd
}
function savewd () {
	if test ${#dirstack} -eq 0 -a "$(pwd)" = "$(sh -c 'cd "$HOME" && pwd')"
	then
		return
	fi
	local file
	if test -z "$1"
	then
		file="$dirstacks/stack$(stamp)_$$"
	else
		file="$dirstacks/stack_$1"
	fi
	writewd > $file
}
function setsavewd () {
	test $# -eq 1 -a -n "$1" || return 1
	_add_chpwd "savewd '$1'"
	chpwd
}
function initwd () {
	test $# -eq 1 -a -n "$1" || return 1
	if test -e "$dirstacks/stack_$1"
	then
		cat "$dirstacks/stack_$1" | readwd
	fi
	setsavewd "$1"
	HISTFILE="$dirstacks/.zsh_history_$1"
	setopt SHARE_HISTORY
	unsetopt INC_APPEND_HISTORY
	unsetopt INC_APPEND_HISTORY_TIME
}
function internal_loadwd_handleChoice () {
	local count=$(lsds | wc -l)
	local choice="$1"
	local show=false
	local file
	eval $(echo x"$choice" | awk '
		/^x$/ { printf("choice=1\n"); next; }
		/^xx$/ { printf("return 1\n"); next; }
		/^x[0-9]+$/ {
			printf("choice=%d\n",
				substr($0, 2));
			next;
		}
		/^x\?[0-9]+$/ {
			printf("show=true;choice=%d\n",
				substr($0, 3));
			next;
		}
		{ printf("choice=-1\n"); }
	')

	if $show || test 0 -ge "$choice" -o "$count" -lt "$choice"
	then
		lsds | awk -F/ '{ print NR, $NF }'
		count=$(lsds | wc -l)
		echo ""
		if $show
		then
			file="$(lsds | tail -n +$choice | head -1)"
			echo "$file":
			echo ""
			cat $file
			echo ""
		fi
		return 0
	else
		file="$(lsds | tail -n +$choice | head -1)"
		readwd < "$file"
		return 1
	fi
}
function loadwd () {
	local choice=${1:-"invalid"}
	#echo ""
	while internal_loadwd_handleChoice "$choice" && read 'choice?Load: '
	do
	done
}
function cleanwd () {
	local pastmax=6
	if test $# -gt 0
	then
		pastmax=$(expr 1 + $1)
	fi
	lsds | tail -n +$pastmax | tr '\012' '\000' | xargs -0 rm
}

alias lwd='writewd > "$cdpipe"'
alias wdl='readwd < "$cdpipe"'

alias ..='cd ..'
alias cd..='cd ..'
alias edtr=ddvim
alias pd=pushd
alias pop=popd

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
			local cmd="`whence -p $1`"
			local filetype="$(file -Lb "$cmd")"
			if expr "$filetype" : '.*\(script\|text\).*' >/dev/null
			then
				$PAGER "$cmd"
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
function viewcert () {
	openssl x509 -text -noout -in "$@" | less
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
	grep "$@" ~/.z{shenv,shrc,login} $(platfile zshenv) $(platfile zshrc)
}
alias ll="edtr ~/.zshrc"
alias lll=". ~/.zshenv; . ~/.zshrc"
alias edenv="edtr ~/.zshenv"
alias edssh="edtr ~/.ssh/config"
alias edk="edtr ~/.ssh/known_hosts"

function md5hostkey () {
	if test $# -ne 1
	then
		echo "Usage: $funcstack[1] <ssh host>" >&2
		return 1
	fi
	ssh-keyscan -t rsa "$1" | ssh-keygen -l -f - -E md5
}

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

alias gw="git which"
alias gst="git status"
alias gitst="git status-relative-porcelain"
alias gita="git add --all"
function gitam () {
	gitst "$@" |\
		sed -n 's/^[M ][M ] //p' |\
		tr '\012' '\000' |\
		xargs -0 git add
}
function gitm () {
	gitst "$@" | grep '^\s\?[?AMU]' | cut -c4-
}
alias gitmr=gitm
function gvi () {
	ddvim -p `gitmr "$@"`
}
function gitc () {
	gitst "$@" | grep '^UU' | cut -c4-
}
function gitcr () {
	local count=$(git pwd | tr -cd / | wc -c)
	gitst "$@" |\
		grep '^UU' |\
		sed 's,...\([^/]\+/\)\{'$count'\},,'
}
function gvc () {
	ddvim -p `gitcr "$@"`
}
function gitjs () {
	gitmr "$@" | grep '\.js$'
}
function gjl () {
	gitjs "$@" | xargs jslint
}
function gtt () {
	local ticketfile="$(git root)/.git/.ticket"
	if test $# -gt 0
	then
		if test x"$1" = "x-"
		then
			rm -f "$ticketfile"
		else
			echo "$@" | tr ' ' ',' > "$ticketfile"
		fi
		return
	fi
	if test -r "$ticketfile"
	then
		cat "$ticketfile"
		return
	fi

	local cur="$(git cur)"
	echo "$cur" |\
		sed -n \
			-e 's/,/	/g' \
			-e 's,^[a-z]\+/\([^/]\+\)\(/.*\)\?$,\1,p' |\
		awk -F '[-]' '
			BEGIN { RS="[\n\t]" }
			($1 ~ /^[A-Z]+$/) && ($2 ~ /^[0-9]+$/) {
				printf("%s-%s\t", $1, $2)
			}
			$1 ~ /^AB#[0-9]+$/ {
				printf("%s\t", $1)
			}
			END { printf("\n") }
		' | tr '\011' ',' | sed 's/,$//'
}
function gtc () {
	if test $# -ge 0 && git cur >/dev/null 2>&1
	then
		local ticket="$(gtt)"
		if test -n "$ticket"
		then
			git commit -m "$ticket"": $*"
		else
			git commit -m "$*"
		fi
	else
		git status
		false
	fi
}

function gdcs () {
	if test $# -gt 0
	then
		local ref='stash@{'"$1"'}'
		shift
	else
		local ref='stash@{0}'
	fi
	git diff "$@" "$ref"^.."$ref"
}

alias master='git checkout $(git default-branch 2>/dev/null || echo master)'
alias ggg="git checkout"
alias ggb="git checkout -b"
alias ggh="git history"
function gg- () {
	git checkout @{-"${1:-"1"}"}
}
alias gg..="git checkout -"
alias gdc="git diff"
alias gdf="git diff --name-status"
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

alias stamp='date -u +%Y-%m-%d_%H:%M:%SZ'

alias google='w3m http://www.google.com/'
function mani () {
	info --subnodes --output - "$1" | $PAGER
}
function localip () {
	ifconfig | grep '\<inet\>' |\
		tr '\011' ' ' | tr -dc '[0-9]. \012' |\
		sed	-e '/^ *127\./d' \
			-e 's/^ *//' \
			-e 's/ .*$//'
}
alias myip='dig +short myip.opendns.com @resolver1.opendns.com'

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
			alias xsu="`zshsulogin`"
		else
			alias xsu="echo Error: Define zshsulogin for this platform"
		fi
	}
fi

function fjs () {
	local findpath="${1:-"."}"
	if test $# -gt 0
	then
		shift
	fi
	find "$findpath" \
		-path './node_modules' -prune \
		-path './css'     -prune \
		-path './docs'    -prune \
		-path './extjs'   -prune \
		-path './ext'     -prune \
		-path './images'  -prune \
		-path './WEB_INF' -prune \
		-o \( \
			-name '*.jsx' \
			-o -name '*.js' \
			-o -name '*.tsx' \
			-o -name '*.ts' \
		\) \
		"$@"
}
function fcs () {
	local findpath="${1:-"."}"
	if test $# -gt 0
	then
		shift
	fi
	find "$findpath" \
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

function ftilde () {
	local findpath="${1:-"."}"
	if test $# -gt 0
	then
		shift
	fi
	find "$findpath" \
		-name '*~' "$@"
}
function rmtilde () {
	local findpath="${1:-"."}"
	ftilde "$findpath" -type f -print0 | xargs -0 -r rm
}

# end aliases
# begin prompt

function _prompt_git () {
	local branch="$(git cur-pretty 2>/dev/null)"
	if test -n "$branch"
	then
		echo '['"$fg[green]$branch$reset_color"'] '
	fi
}
function _prompt_dirs () {
	(pwd; for dir in "$dirstack[@]"; do print "$dir"; done) |\
		sed -f <(cat $(platfile -l promptdirs.sed)) \
			-e '1s,^.*$,'"$bg_bold[cyan] & $reset_color," \
			-e '2,$s/^/'"$fg[blue]|$reset_color "/
}

function _ls_chpwd () {
	for func in "$chpwdfuncs[@]"
	do
		printf '%s\n' "$func"
	done
}
function _add_chpwd () {
	local oldIFS="$IFS"
	local tmpf=$(mktemp)
	_ls_chpwd > $tmpf
	printf '%s\n' "$*" >> $tmpf
	IFS=$'\n'
	chpwdfuncs=($(sort -u $tmpf))
	rm -f $tmpf
	IFS="$oldIFS"
}
function _rm_chpwd () {
	test $# -eq 1 -a -n "$1" || return 1
	local oldIFS="$IFS"
	local tmpf=$(mktemp)
	_ls_chpwd > $tmpf
	IFS=$'\n'
	chpwdfuncs=($(grep -v "$1" $tmpf))
	rm -f $tmpf
	IFS="$oldIFS"
}

function chpwd () {
	for func in "$chpwdfuncs[@]"
	do
		eval "$func"
	done
}
prompt="%m %~ %B%#%b "
if test -n "$xprompt"
then
	function precmd () {
		local NEWLINE=$'\n'
		local PREFIX=""
		local COMMON="%m $(_prompt_git)$(_prompt_dirs)${NEWLINE}%# "
		if test ${#dirstack} -gt 0
		then
			PREFIX="$fg_bold[blue]+$reset_color "
		fi
		prompt="${PREFIX}${COMMON}"
	}
	if test "$xprompt" = title
	then
		_add_chpwd "print -nP '\\033]0;%m: %~\\007'"
		chpwd
	fi
else
	function precmd () { }
	unfunction precmd
	function chpwd () { }
	unfunction chpwd
fi

# end prompt
# begin keybinding

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

# end keybinding

#WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>'
WORDCHARS=\'\"'[]{}()<>^$%~_.'

sourceExtra="`platfile zshrc`"
for s in $sourceExtra
do
	. $s
done

# begin conditional aliases

if test -n "$FFPASS" && command -v nss-passwords >/dev/null
then
	alias ffpass="nss-passwords -d $FFPASS"
fi

if test -n "$NUGETEXE"
then
	NUGETSOURCEFLAG="-source"
	if test -n "$NUGETLOCAL"
	then
		function nulocal () {
			local cmd="$1"
			shift
			nuget "$cmd" "$NUGETSOURCEFLAG" "$NUGETLOCAL" "$@"
		}
	fi
	if echo "$NUGETEXE" | grep 'dotnet$' >/dev/null
	then
		alias nuget='dotnet nuget'
		NUGETSOURCEFLAG="--source"
	fi
fi

# end conditional aliases

mkxsu
trap savewd EXIT
