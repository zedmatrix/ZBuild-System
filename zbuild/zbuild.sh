#!/bin/bash
# build script for use with automation
# export BUILD_USER, BUILD_GROUP, BUILD_ROOT, BUILD_SOURCE
#
#   Requires archive, package, packagedir
#   verify the archive is in BUILD_SOURCE
#
if [[ -z $archive || -z $package || -z $packagedir ]]; then
    echo "*** Check $archive *** $package *** $packagedir ***"
    echo "___Error: Check Export Variables. Exiting."
    exit 1
fi
if [[ -e "$BUILD_SOURCE/${archive}" ]]; then
        pushd $BUILD_ROOT

	if [ "$extract" = "true" ]; then 
	        echo "*** Extracting $archive ***"
	        tar xf "$BUILD_SOURCE/${archive}"
	else
		echo "*** Skipping Extraction ***"
	fi

        if [[ -d "$BUILD_ROOT/${packagedir}" ]]; then
                pushd $BUILD_ROOT/$packagedir

# Run a $patch if set
                if [ ! "$patch" = "false" ] && [ -f $BUILD_SOURCE/$patch ]; then
                        echo "*** Patching $package with ${patch} ***"
                        patch -Np1 -i $BUILD_SOURCE/$patch
		else
			echo "*** Skipping Patch ***"
                fi

# Src_prepare or exit
                if declare -f Src_prepare > /dev/null; then
                    Src_prepare
                else
                    echo "__Error__ Src_prepare not set. Exiting."
                    exit 99
                fi
# Src_configure
                if declare -f Src_configure > /dev/null; then
                    Src_configure
                else
                    echo "__Error__ Src_configure not set. Exiting. "
                    exit 88
                fi

# Src_compile
                if declare -f Src_compile > /dev/null; then
                    Src_compile
                else
                    echo "__Error__ Src_compile not set. Exiting. "
                    exit 77
                fi

# Src_Check
                if declare -f Src_check > /dev/null; then
                     Src_check
                else
                     echo "__Error__ Src_check not set. Exiting."
                     exit 66
                fi
# Src_install
                if declare -f Src_install > /dev/null; then
                     Src_install
                else
                     echo "__Error Src_install not found. Exiting."
                     exit 55
                fi
                if [[ $? -ne 0 ]]; then
                    echo "*** Installation of ${package} Failed. Exiting. ***"
                    exit $?
                fi

# back to BUILD_ROOT
                popd

# Src_post function
                if declare -f Src_post > /dev/null; then
                    Src_post

		    if [ "$delete" = "true" ]; then
                        echo "*** Cleaning Up $BUILD_ROOT/${packagedir} ***"
 	                rm -rf $BUILD_ROOT/${packagedir}
		    else
			echo "*** Not Removing Source Folder ***"
                    fi

                fi
        else
                echo "*** Error *** Extraction Failed. $BUILD_ROOT | ${packagedir} ***"
                exit 1
        fi

else
        echo "*** Error *** Archive Not Found. ${archive}"
        exit 1
fi
