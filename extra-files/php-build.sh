#!/bin/bash


#https://frankenphp.dev/docs/compile/

apt-get install re2c libtool pkg-config automake autoconf libxml2-dev libjpeg-dev libpng-dev libwebp-dev libcurl4-openssl-dev libssl-dev libmcrypt-dev mcrypt libmysqlclient-dev libsqlite3-dev libpq-dev autopoint debhelper dh-autoreconf dh-strip-nondeterminism dwz gettext intltool-debian libarchive-cpio-perl libarchive-zip-perl libdebhelper-perl libfile-stripnondeterminism-perl libmail-sendmail-perl libpcre2-32-0 libpcre2-dev libpcre2-posix3 libsys-hostname-long-perl shtool brotli  libbrotli-dev libonig-dev libbison-dev bison brotli-rs  libbrotli-dev golang-github-andybalholm-brotli-dev libbrotli1 libbz2-dev libgmp-dev libzip-dev libzip-dev libwebp-dev libjpeg-dev libpng-dev libfreetype-dev libicu-dev libgettextpo-dev libldap2-dev libpq-dev libtidy-dev libxslt-dev libsnmp-dev libsodium-dev gettext



./configure --enable-embed --enable-zts --disable-zend-signals --enable-zend-max-execution-timers \
  --with-config-file-path=/etc  --with-zlib --with-openssl --with-curl --with-pdo-mysql=mysqlnd \
 --enable-mbstring --enable-soap  --enable-sockets

apt-get install brotli-rs  libbrotli-dev golang-github-andybalholm-brotli-dev libbrotli1







cd /opt/
curl -L https://github.com/e-dant/watcher/archive/refs/heads/next.tar.gz | tar xz
cd watcher-next/watcher-c
c++ -o libwatcher-c.so ./src/watcher-c.cpp -I ./include -I ../include -std=c++17 -fPIC -shared
cp libwatcher-c.so /usr/local/lib/libwatcher-c.so
ldconfig
cp -pRv /opt/watcher-next/watcher-c/include/wtr /usr/include/





CGO_ENABLED=1 \
XCADDY_GO_BUILD_FLAGS="-ldflags='-w -s' -tags=nobadger,nomysql,nopgx,nobrotli,nowatcher" \
CGO_CFLAGS=$(php-config --includes) \
CGO_LDFLAGS="$(php-config --ldflags) $(php-config --libs)" \
xcaddy build \
    --output frankenphp \
    --with github.com/dunglas/frankenphp/caddy \
    --with github.com/dunglas/mercure/caddy \
    --with github.com/dunglas/vulcain/caddy \


