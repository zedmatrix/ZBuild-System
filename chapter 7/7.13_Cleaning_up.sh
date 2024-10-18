echo "* remove info-man-doc"
rm -rf /usr/share/{info,man,doc}/*

echo "* find and remove libtool archive files"
find /usr/{lib,libexec} -name \*.la -delete

echo "* remove temp tools"
rm -rf /tools

echo "*** at this point you can backup ***"
