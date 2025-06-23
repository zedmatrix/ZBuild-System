#!/bin/bash
SOURCES=${SOURCES:-/sources}
CFLAGS=${CFLAGS:-"-Os -pipe"}
CXXFLAGS=${CXXFLAGS:-"$CFLAGS"}

# https://skarnet.org/software/skalibs/skalibs-2.14.4.0.tar.gz
export PACKAGE=skalibs-2.14.4.0
bsdtar -xf $SOURCES/skalibs-2.14.4.0.tar.gz && pushd $PACKAGE

./configure --prefix=/usr

make

make install

# Installed Support Libraries: /usr/lib/skalibs/sysdeps
## /usr/lib/skalibs/sysdeps/pthread.lib
## /usr/lib/skalibs/sysdeps/socket.lib
## /usr/lib/skalibs/sysdeps/spawn.lib
## /usr/lib/skalibs/sysdeps/sysclock.lib
## /usr/lib/skalibs/sysdeps/sysdeps
## /usr/lib/skalibs/sysdeps/target
## /usr/lib/skalibs/sysdeps/timer.lib
## /usr/lib/skalibs/sysdeps/util.lib

# Installed Libraries:
## /usr/lib/libskarnet.so.2.14.4.0
## /usr/lib/libskarnet.so.2.14
## /usr/lib/libskarnet.so
## /usr/lib/libskarnet.a

# Installed Headers:
## /usr/include/skalibs
# alarm.h  bytestr.h  djbtime.h  gensetdyn.h  segfault.h  stat.h  uint32.h
# alloc.h  cbuffer.h  djbunix.h  genwrite.h   selfpipe.h  stdcrypto.h  uint64.h
# allreadwrite.h  cdb.h  env.h  gol.h  setgroups.h  stddjb.h  unix-timed.h
# ancil.h  cdbmake.h  envalloc.h  iopause.h  sgetopt.h  stralloc.h  unix-transactional.h
# avlnode.h  config.h  error.h  ip46.h  sha1.h  strerr.h  unixconnection.h
# avltree.h  cplz.h  exec.h  kolbak.h  sha256.h  strerr2.h  unixmessage.h
# avltreen.h  cspawn.h  fcntl.h  lolstdio.h  sha512.h  surf.h  unixonacid.h
# bigkv.h         datastruct.h  fmtscan.h        netstring.h    sig.h        sysdeps.h
# bitarray.h      devino.h      functypes.h      nonposix.h     siovec.h     tai.h
# blake2s.h       direntry.h    gccattributes.h  nsig.h         skaclient.h  textclient.h
# bsdsnowflake.h  disize.h      genalloc.h       posixishard.h  skalibs.h    textmessage.h
# bufalloc.h      diuint.h      genqdyn.h        posixplz.h     skamisc.h    types.h
# buffer.h        diuint32.h    genset.h         random.h       socket.h     uint16.h

popd

rm -rf $PACKAGE

echo -e "============================================================================"
# https://skarnet.org/software/mdevd/mdevd-0.1.7.0.tar.gz

export PACKAGE=mdevd-0.1.7.0
bsdtar -xf $SOURCES/mdevd-0.1.7.0.tar.gz && pushd $PACKAGE

./configure --prefix=/usr

make

make install
## Installed:
# /usr/bin/mdevd
# /usr/bin/mdevd-coldplug
# /usr/include/mdevd/config.h

popd

rm -rf $PACKAGE
