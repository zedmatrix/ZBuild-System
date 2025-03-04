# install --directory --mode=0755 --owner=root --group=root /etc/profile.d
# install --directory --mode=0755 --owner=root --group=root /etc/bash_completion.d
EXTRABASHDIR=/etc/bash_completion.d
RSRCDIR=rootfiles/
RSRCFILES=bash_login bash_logout bash_profile bashrc profile
RDESTFILES=.bash_login .bash_logout .bash_profile .bashrc .profile

ESRCDIR=etcfiles/
EPROFILESRC=$(ESRCDIR)/profile.d

ESRCFILES=bashrc profile locale.conf vconsole.conf \
	resolv.conf inputrc shells fstab motd issue adjtime hosts

EDESTDIR=/etc
EPROFILEDEST=/etc/profile.d
EPROFILESRCFILES=bash_completion.sh dircolors.sh extrapaths.sh i18n.sh readline.sh umask.sh \
	CurlPaste.sh PackageCheck.sh Source_wget.sh zbuild3.sh
ESKELDIR=/etc/skel

#Default Target
all: install-root install-extra install-skel

#Install-root
install-root:
	@echo "Installing Root Startup Files to /root"
	for src in $(RSRCFILES); do \
		dest=".$$(basename $$src)"; \
		install -v -m644 -o root -g root $(RSRCDIR)/$$src /root/$$dest; \
	done


#Install-extra
install-extra:
	@echo "Installing Extra Profile "
	install -v -d -m 755 -o root -g root $(EXTRABASHDIR)
	install -v -d -m 755 -o root -g root $(EPROFILEDEST)

	for src in $(ESRCFILES); do \
		install -v -m 644 -o root -g root $(ESRCDIR)/$$src $(EDESTDIR)/$$src; \
	done
	for src in $(EPROFILESRCFILES); do \
		install -v -m 644 -o root -g root $(EPROFILESRC)/$$src $(EPROFILEDEST)/$$src; \
	done

#Install-skel
install-skel:
	@echo "Installing /etc/skel files and directories"
		install -v -d -m 755 -o root -g root $(ESKELDIR)
	for src in $(RSRCFILES); do \
		dest=".$$(basename $$src)"; \
		install -v -m644 -o root -g root $(RSRCDIR)/$$src $(ESKELDIR)/$$dest; \
	done

#Clean-root
clean-root:
	@echo "Cleaning Root Startup Files from /root"
	for src in $(RDESTFILES); do \
		rm -v /root/$$src \
	done

#Clean-extra
clean-extra:
	@echo "Cleaning Extra Profile"
	for src in $(ESRCFILES); do \
		rm -v $(EDESTDIR)/$src; \
	done
	for src in $(EPROFILESRCFILES); do \
		rm -v $(EPROFILEDEST)/$src; \
	done

clean-skel:
	@echo "Cleaning /etc/skel Startup Files"
	for src in $(RDESTFILES); do \
		rm -v $(ESKELDIR)/$$src \
	done

.PHONY: all install-root clean-root install-extra clean-extra install-skel clean-skel
