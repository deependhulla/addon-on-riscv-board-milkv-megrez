#!/bin/bash


#https://frankenphp.dev/docs/compile/

apt-get install re2c libtool pkg-config automake autoconf libxml2-dev libjpeg-dev libpng-dev libwebp-dev libcurl4-openssl-dev libssl-dev libmcrypt-dev mcrypt libmysqlclient-dev libsqlite3-dev libpq-dev autopoint debhelper dh-autoreconf dh-strip-nondeterminism dwz gettext intltool-debian libarchive-cpio-perl libarchive-zip-perl libdebhelper-perl libfile-stripnondeterminism-perl libmail-sendmail-perl libpcre2-32-0 libpcre2-dev libpcre2-posix3 libsys-hostname-long-perl shtool brotli  libbrotli-dev

#https://github.com/e-dant/watcher/tree/release/watcher-c

cd /opt/
curl -L https://github.com/e-dant/watcher/archive/refs/heads/next.tar.gz | tar xz
cd watcher-next/watcher-c
c++ -o libwatcher-c.so ./src/watcher-c.cpp -I ./include -I ../include -std=c++17 -fPIC -shared
cp libwatcher-c.so /usr/local/lib/libwatcher-c.so
ldconfig

