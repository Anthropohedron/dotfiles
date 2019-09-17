# vim: set ft=make:

SRCDIR=ssh_config.d

config: $(SRCDIR) $(SRCDIR)/*.conf
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
	ls -1 $(SRCDIR)/*.conf | sort | xargs cat >> $@
	chmod 600 $@

