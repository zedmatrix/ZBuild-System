#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	docbook-xsl-nons-1.79.2
#
#    unset functions
unset -f Src_prepare
unset -f Src_configure
unset -f Src_compile
unset -f Src_check
unset -f Src_install
#
# Global Settings
#
ZBUILD_root=/zbuild
ZBUILD_script=${ZBUILD_root}/zbuild4.sh
ZBUILD_log=${ZBUILD_root}/Zbuild_log
[ ! -d ${ZBUILD_root} ] && { echo "Error: ${ZBUILD_root} directory Missing. Exiting."; exit 2; }
[ ! -d ${ZBUILD_log} ] && mkdir -v $ZBUILD_log
[ ! -f ${ZBUILD_script} ] && { echo "ERROR: Missing ${ZBUILD_script}. Exiting."; exit 3; }

# pkgurl = archive
pkgname=docbook-xsl-nons
pkgver=1.79.2
pkgurl="https://github.com/docbook/xslt10-stylesheets/releases/download/release/1.79.2/docbook-xsl-nons-1.79.2.tar.bz2"
pkgpatch="docbook-xsl-nons-1.79.2-stack_fix-1.patch"
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
#
#   Build Functions
#
Src_prepare() {
	tar -xf /sources/docbook-xsl-doc-1.79.2.tar.bz2 --strip-components=1 || return 99
}
Src_configure() {
	install -v -m755 -d /usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2
	cp -v -R VERSION assembly common eclipse epub epub3 extensions fo \
         highlighting html htmlhelp images javahelp lib manpages params \
         profiling roundtrip slides template tests tools webhelp website \
         xhtml xhtml-1_1 xhtml5  /usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2

	ln -s VERSION /usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2/VERSION.xsl

	install -v -m644 -D README /usr/share/doc/docbook-xsl-nons-1.79.2/README.txt
	install -v -m644    RELEASE-NOTES* NEWS* /usr/share/doc/docbook-xsl-nons-1.79.2
	cp -v -R doc/* /usr/share/doc/docbook-xsl-nons-1.79.2
}
Src_compile() {
	if [ ! -d /etc/xml ]; then install -v -m755 -d /etc/xml; fi
	if [ ! -f /etc/xml/catalog ]; then
	    xmlcatalog --noout --create /etc/xml/catalog
	fi

	xmlcatalog --noout --add "rewriteSystem" "http://cdn.docbook.org/release/xsl-nons/1.79.2" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" /etc/xml/catalog
	xmlcatalog --noout --add "rewriteSystem" "https://cdn.docbook.org/release/xsl-nons/1.79.2" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" /etc/xml/catalog
	xmlcatalog --noout --add "rewriteURI" "http://cdn.docbook.org/release/xsl-nons/1.79.2" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" /etc/xml/catalog
	xmlcatalog --noout --add "rewriteURI" "https://cdn.docbook.org/release/xsl-nons/1.79.2" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" /etc/xml/catalog
	xmlcatalog --noout --add "rewriteSystem" "http://cdn.docbook.org/release/xsl-nons/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" /etc/xml/catalog
	xmlcatalog --noout --add "rewriteSystem" "https://cdn.docbook.org/release/xsl-nons/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" /etc/xml/catalog
	xmlcatalog --noout --add "rewriteURI" "http://cdn.docbook.org/release/xsl-nons/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" /etc/xml/catalog
	xmlcatalog --noout --add "rewriteURI" "https://cdn.docbook.org/release/xsl-nons/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" /etc/xml/catalog
	xmlcatalog --noout --add "rewriteSystem" "http://docbook.sourceforge.net/release/xsl/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" /etc/xml/catalog
	xmlcatalog --noout --add "rewriteURI" "http://docbook.sourceforge.net/release/xsl/current" \
           "/usr/share/xml/docbook/xsl-stylesheets-nons-1.79.2" /etc/xml/catalog
}
Src_install() {
	return 0
}
export pkgname pkgver pkgurl pkgdir pkgpatch zdelete
export -f Src_prepare
export -f Src_configure
export -f Src_compile
export -f Src_install

if [ -f ${ZBUILD_script} ]; then
    ${ZBUILD_script}
    exitcode=$?
else
    printf "\n\t Error: Missing ZBUILD_script. \n"
    exitcode=2
fi

if [[ $exitcode -ne 0 ]]; then
    printf "\n\t Error Code: ${exitcode} \n"
else
    printf "\t Success \n"
    unset -f Src_prepare
    unset -f Src_configure
    unset -f Src_compile
    unset -f Src_install
    unset pkgname pkgver pkgurl pkgdir pkgpatch zdelete
fi
