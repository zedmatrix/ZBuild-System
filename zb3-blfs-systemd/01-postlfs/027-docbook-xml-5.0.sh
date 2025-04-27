#!/bin/bash
#       Install Zbuild v3.4 - LFS - Base System
#
#	docbook-xml-5.0
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
pkgname=docbook-xml
pkgver=5.0
pkgurl="https://docbook.org/xml/5.0/docbook-5.0.zip"
pkgpatch=""
zdelete="true"
#   Configure
pkgdir=${pkgname}-${pkgver}
#
#   Build Functions
#
Src_configure() {
	cd docbook-5.0
	install -vdm755 /usr/share/xml/docbook/schema/{dtd,rng,sch,xsd}/5.0
	install -vm644  dtd/* /usr/share/xml/docbook/schema/dtd/5.0
	install -vm644  rng/* /usr/share/xml/docbook/schema/rng/5.0
	install -vm644  sch/* /usr/share/xml/docbook/schema/sch/5.0
	install -vm644  xsd/* /usr/share/xml/docbook/schema/xsd/5.0
}
Src_compile() {
	xmlcatalog --noout --create /usr/share/xml/docbook/schema/dtd/5.0/catalog.xml

	xmlcatalog --noout --add "public" "-//OASIS//DTD DocBook XML 5.0//EN" \
	  "docbook.dtd" /usr/share/xml/docbook/schema/dtd/5.0/catalog.xml
	xmlcatalog --noout --add "system" "http://www.oasis-open.org/docbook/xml/5.0/dtd/docbook.dtd" \
	  "docbook.dtd" /usr/share/xml/docbook/schema/dtd/5.0/catalog.xml
}
Src_check() {
	xmlcatalog --noout --create /usr/share/xml/docbook/schema/rng/5.0/catalog.xml
	xmlcatalog --noout --add "uri" "http://docbook.org/xml/5.0/rng/docbook.rng" \
  "docbook.rng" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml
	xmlcatalog --noout --add "uri" "http://www.oasis-open.org/docbook/xml/5.0/rng/docbook.rng" \
  "docbook.rng" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml
	xmlcatalog --noout --add "uri" "http://docbook.org/xml/5.0/rng/docbookxi.rng" \
  "docbookxi.rng" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml
	xmlcatalog --noout --add "uri" "http://www.oasis-open.org/docbook/xml/5.0/rng/docbookxi.rng" \
  "docbookxi.rng" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml
	xmlcatalog --noout --add "uri" "http://docbook.org/xml/5.0/rng/docbook.rnc" \
  "docbook.rnc" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml
	xmlcatalog --noout --add "uri" "http://www.oasis-open.org/docbook/xml/5.0/rng/docbook.rnc" \
  "docbook.rnc" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml
	xmlcatalog --noout --add "uri" "http://docbook.org/xml/5.0/rng/docbookxi.rnc" \
  "docbookxi.rnc" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml
	xmlcatalog --noout --add "uri" "http://www.oasis-open.org/docbook/xml/5.0/rng/docbookxi.rnc" \
  "docbookxi.rnc" /usr/share/xml/docbook/schema/rng/5.0/catalog.xml

}
Src_install() {
	xmlcatalog --noout --create /usr/share/xml/docbook/schema/sch/5.0/catalog.xml
	xmlcatalog --noout --add "uri" "http://docbook.org/xml/5.0/sch/docbook.sch" \
  "docbook.sch" /usr/share/xml/docbook/schema/sch/5.0/catalog.xml
	xmlcatalog --noout --add "uri" "http://www.oasis-open.org/docbook/xml/5.0/sch/docbook.sch" \
  "docbook.sch" /usr/share/xml/docbook/schema/sch/5.0/catalog.xml

	xmlcatalog --noout --create /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml
	xmlcatalog --noout --add "uri" "http://docbook.org/xml/5.0/xsd/docbook.xsd" \
  "docbook.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml
	xmlcatalog --noout --add "uri" "http://www.oasis-open.org/docbook/xml/5.0/xsd/docbook.xsd" \
  "docbook.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml
	xmlcatalog --noout --add "uri" "http://docbook.org/xml/5.0/xsd/docbookxi.xsd" \
  "docbookxi.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml
	xmlcatalog --noout --add "uri" "http://www.oasis-open.org/docbook/xml/5.0/xsd/docbookxi.xsd" \
  "docbookxi.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml
	xmlcatalog --noout --add "uri" "http://docbook.org/xml/5.0/xsd/xlink.xsd" \
  "xlink.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml
	xmlcatalog --noout --add "uri" "http://www.oasis-open.org/docbook/xml/5.0/xsd/xlink.xsd" \
   "xlink.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml
	xmlcatalog --noout --add "uri" "http://docbook.org/xml/5.0/xsd/xml.xsd" \
   "xml.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml
	xmlcatalog --noout --add "uri" "http://www.oasis-open.org/docbook/xml/5.0/xsd/xml.xsd" \
   "xml.xsd" /usr/share/xml/docbook/schema/xsd/5.0/catalog.xml
}
Src_post() {
	if [ ! -e /etc/xml/catalog ]; then
	    install -v -d -m755 /etc/xml
    	xmlcatalog --noout --create /etc/xml/catalog
	fi
	xmlcatalog --noout --add "delegatePublic" "-//OASIS//DTD DocBook XML 5.0//EN" \
  "file:///usr/share/xml/docbook/schema/dtd/5.0/catalog.xml" /etc/xml/catalog
	xmlcatalog --noout --add "delegateSystem" "http://docbook.org/xml/5.0/dtd/" \
  "file:///usr/share/xml/docbook/schema/dtd/5.0/catalog.xml" /etc/xml/catalog
	xmlcatalog --noout --add "delegateURI" "http://docbook.org/xml/5.0/dtd/" \
  "file:///usr/share/xml/docbook/schema/dtd/5.0/catalog.xml" /etc/xml/catalog
	xmlcatalog --noout --add "delegateURI" "http://docbook.org/xml/5.0/rng/" \
  "file:///usr/share/xml/docbook/schema/rng/5.0/catalog.xml" /etc/xml/catalog
	xmlcatalog --noout --add "delegateURI" "http://docbook.org/xml/5.0/sch/"  \
  "file:///usr/share/xml/docbook/schema/sch/5.0/catalog.xml" /etc/xml/catalog
	xmlcatalog --noout --add "delegateURI" "http://docbook.org/xml/5.0/xsd/"  \
  "file:///usr/share/xml/docbook/schema/xsd/5.0/catalog.xml" /etc/xml/catalog
}
export pkgname pkgver pkgurl pkgdir zdelete
export -f Src_configure
export -f Src_compile
export -f Src_check
export -f Src_install
export -f Src_post

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
    unset -f Src_configure
    unset -f Src_compile
	unset -f Src_check
    unset -f Src_install
    unset -f Src_post
    unset pkgname pkgver pkgurl pkgdir zdelete
fi
