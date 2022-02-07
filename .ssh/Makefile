# vim: set ft=make:

BASEDIR=ssh_config.d
PRIVATEDIR=$(HOME)/.dotprivate/ssh_config.d
LOCALDIR=$(HOME)/.local/ssh_config.d

BASECONF=$(wildcard ssh_config.d/*.conf)
PRIVATECONF=$(wildcard $(HOME)/.dotprivate/ssh_config.d/*.conf)
LOCALCONF=$(wildcard $(HOME)/.local/ssh_config.d/*.conf)

config: $(BASECONF) $(PRIVATECONF) $(LOCALCONF)
	echo '# vim: set ft=sshconfig:' > $@
	(                                          \
		   command -v /usr/bin/xauth       \
		|| command -v /opt/local/bin/xauth \
		|| command -v /opt/X11/bin/xauth   \
		|| command -v /usr/X11/bin/xauth   \
		|| command -v /usr/X11R6/bin/xauth \
		|| command -v /usr/local/bin/xauth \
		|| command -v xauth                \
	) | sed 's/^/XAuthLocation /' >> $@
	ls -1 $^ | \
		awk -F / '{ print $$NF " " $$0 }' | \
		sort | \
		cut -d\  -f2 | \
		xargs cat >> $@
	chmod 600 $@

