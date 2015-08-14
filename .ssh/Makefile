SRCDIR=ssh_config.d

config: $(SRCDIR) $(SRCDIR)/*.conf
	ls -1 $(SRCDIR)/*.conf | sort | xargs cat > $@
	chmod 600 $@


