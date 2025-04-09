printf "\t Configure and Testing Glibc-2.41 \n"

sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd
mkdir -pv test-glibc

pushd test-glibc

echo 'int main(){}' | $LFS_TGT-gcc -x c - -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
grep -E -o "$LFS/lib.*/S?crt[1in].*succeeded" dummy.log
grep -B3 "^ $LFS/usr/include" dummy.log
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
grep "/lib.*/libc.so.6 " dummy.log
grep found dummy.log

popd

printf "\n\t Finished \n"

