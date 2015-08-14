#!/bin/sh

if test "$COLUMNS" = ""
then
	eval `/usr/bin/resize -u`
fi

if test "$COLUMNS" -le 60
then
	cat <<-'EOF'
	set index_format="%Z %C %-10.10L |%s"
	ignore *
	unignore Date Subject From To
	EOF
fi
