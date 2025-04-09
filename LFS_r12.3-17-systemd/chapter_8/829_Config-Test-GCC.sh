printf " \n\t Configuring and Testing GCC \n "
mkdir -pv gcc-tests

pushd gcc-tests

grep -A7 Summ /zbuild/Zbuild_log/gcc-14.2.0-check.log

echo 'int main(){}' | cc dummy.c -x c - -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'

grep -E -o '/usr/lib.*/S?crt[1in].*succeeded' dummy.log

grep -B4 '^ /usr/include' dummy.log
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
grep "/lib.*/libc.so.6 " dummy.log
grep found dummy.log
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

popd

printf " \n\t All Tests Done - you can remove gcc-tests \n "
