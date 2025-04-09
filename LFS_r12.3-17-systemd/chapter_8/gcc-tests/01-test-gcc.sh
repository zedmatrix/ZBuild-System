readelf -l a.out | grep ': /lib'
grep -E -o '/usr/lib.*/S?crt[1in].*succeeded' hello.log
grep -B4 '^ /usr/include' hello.log
grep 'SEARCH.*/usr/lib' hello.log |sed 's|; |\n|g'
grep "/lib.*/libc.so.6 " hello.log
grep found hello.log
