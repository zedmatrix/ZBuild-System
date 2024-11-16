#!/bin/bash
if [ -n "$LFS" ] && [ -d "$LFS" ]; then
   echo "* Good $LFS is set *"
   
   if [ -d "${ZBUILD_sources}" ] && [ -n "${ZBUILD_sources}" ]; then
      echo "* Good ${ZBUILD_sources} is set and exists *"
   
      chmod -v a+wt "$ZBUILD_sources"
      
      pushd $ZBUILD_sources
        if [ -f wget-list ] && [ -f md5sums ]; then
          wget --input-file=wget-list --continue
          md5sum -c md5sums
          chown root:root "${ZBUILD_sources}/*"
          echo "* Finished Getting Sources to: ${ZBUILD_sources} *"
        else
          echo "Error: make sure 'wget-list' and 'md5sums' are in ${ZBUILD_sources}"
        fi
      popd
   else
      echo "Error: {ZBUILD_sources} is not available. *"
   fi
else
   echo "Error: {LFS} is not available"
fi
