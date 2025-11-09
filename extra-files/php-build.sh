#!/bin/bash

#To Complie PHP first ,then get frankenphp
#https://frankenphp.dev/docs/compile/

apt-get install re2c libtool pkg-config automake autoconf libxml2-dev libjpeg-dev libpng-dev libwebp-dev libcurl4-openssl-dev libssl-dev libmcrypt-dev mcrypt libmysqlclient-dev libsqlite3-dev libpq-dev autopoint debhelper dh-autoreconf dh-strip-nondeterminism dwz gettext intltool-debian libarchive-cpio-perl libarchive-zip-perl libdebhelper-perl libfile-stripnondeterminism-perl libmail-sendmail-perl libpcre2-32-0 libpcre2-dev libpcre2-posix3 libsys-hostname-long-perl shtool brotli  libbrotli-dev libonig-dev libbison-dev bison brotli-rs  libbrotli-dev golang-github-andybalholm-brotli-dev libbrotli1 libbz2-dev libgmp-dev libzip-dev libzip-dev libwebp-dev libjpeg-dev libpng-dev libfreetype-dev libicu-dev libgettextpo-dev libldap2-dev libpq-dev libtidy-dev libxslt-dev libsnmp-dev libsodium-dev gettext libffi-dev


cd /opt/



curl -L https://github.com/e-dant/watcher/archive/refs/heads/next.tar.gz | tar xz
cd watcher-next/watcher-c
c++ -o libwatcher-c.so ./src/watcher-c.cpp -I ./include -I ../include -std=c++17 -fPIC -shared
cp libwatcher-c.so /usr/local/lib/libwatcher-c.so
ldconfig
cp -pRv /opt/watcher-next/watcher-c/include/wtr /usr/include/

cd /opt/
wget -c https://github.com/caddyserver/xcaddy/releases/download/v0.4.5/xcaddy_0.4.5_linux_riscv64.deb
dpkg -i xcaddy_0.4.5_linux_riscv64.deb
wget -c https://go.dev/dl/go1.25.4.linux-riscv64.tar.gz
tar -xzf go1.25.4.linux-riscv64.tar.gz
wget -c https://www.php.net/distributions/php-8.4.14.tar.gz
tar -xzf php-8.4.14.tar.gz

git clone https://github.com/php/frankenphp

export PATH=/opt/go/bin/:/usr/local/bin:$PATH

cd /opt/php-8.4.14
./configure --enable-embed --enable-zts --disable-zend-signals --enable-zend-max-execution-timers \
 --with-config-file-path=/etc --with-zlib --with-openssl --with-curl --with-pdo-mysql=mysqlnd \
 --enable-mbstring --enable-soap --enable-sockets --enable-bcmath --with-bz2 \
 --enable-calendar --enable-exif --enable-ftp --with-gmp --enable-shmop \
 --enable-sysvmsg --enable-sysvsem --enable-sysvshm  \
 --enable-pcntl --with-zip --enable-intl --with-gettext --with-ldap \
 --with-pdo-pgsql --with-pgsql --with-tidy --with-xsl --with-snmp --with-sodium --with-ffi

make -j"$(getconf _NPROCESSORS_ONLN)"
make test
make install

cd /opt/
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

cd /opt/frankenphp

CGO_ENABLED=1 \
XCADDY_GO_BUILD_FLAGS="-ldflags='-w -s' -tags=nobadger,nomysql,nopgx,nobrotli,nowatcher" \
CGO_CFLAGS=$(php-config --includes) \
CGO_LDFLAGS="$(php-config --ldflags) $(php-config --libs)" \
xcaddy build \
    --output frankenphp \
    --with github.com/dunglas/frankenphp/caddy \
    --with github.com/dunglas/mercure/caddy \
    --with github.com/dunglas/vulcain/caddy \





CGO_ENABLED=1 \
XCADDY_GO_BUILD_FLAGS="-ldflags='-w -s' -tags=nobadger,nomysql,nopgx,nobrotli,nowatcher" \
CGO_CFLAGS=$(php-config --includes) \
CGO_LDFLAGS="$(php-config --ldflags) $(php-config --libs)" \
xcaddy build \
    --output frankenphp \
    --with github.com/dunglas/frankenphp/caddy \
    --with github.com/dunglas/mercure/caddy \
    --with github.com/dunglas/vulcain/caddy \


