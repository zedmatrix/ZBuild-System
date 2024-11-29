#!/bin/bash
wget="${PWD}/301-wgetlist"
md5="${PWD}/301-md5sums"
[ ! -f $wget ] && { echo "Missing $wget"; exit 1; }
[ ! -f $md5 ] && { echo "Missing $md5"; exit 1; }

if [ -n "$LFS" ] && [ -d "$LFS" ]; then
   echo "* Good $LFS is set *"
   
   if [ -d "${ZBUILD_sources}" ] && [ -n "${ZBUILD_sources}" ]; then
      echo "* Good ${ZBUILD_sources} is set and exists *"
      chmod -v a+wt "$ZBUILD_sources"
      
      pushd $ZBUILD_sources
          grep -v '^#' $wget | awk '{print $1}' | wget -i- -c
          md5sum -c $md5 > "${ZBUILD_log}/301_wgetlist.log"
          chown root:root "${ZBUILD_sources}/*"
          echo "* Finished Getting Sources to: ${ZBUILD_sources} *"
      popd
   else
      echo "Error: {ZBUILD_sources} is not available. *"
   fi
else
   echo "Error: {LFS} is not available"
fi
