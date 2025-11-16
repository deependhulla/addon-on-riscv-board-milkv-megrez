#!/bin/bash



# Navigate into the PHP source directory.
cd /opt/php-8.4.14
make clean
# Configure PHP compilation with necessary flags for embedding and extensions.
# --enable-embed and --enable-zts are critical for FrankenPHP integration.
./configure --enable-embed=static --enable-zts --disable-zend-signals \
 --enable-zend-max-execution-timers --with-bz2 --with-curl --enable-gd --with-jpeg --with-webp --with-avif \
 --enable-intl --with-ffi --enable-exif --with-ldap --enable-mbstring --with-openssl --with-pdo-mysql=mysqlnd \
 --with-readline --enable-sockets --with-sodium --enable-soap --with-libxml --with-zip --with-mysqli=mysqlnd \
 --enable-sysvsem  --enable-sysvshm --enable-sysvmsg --enable-soap --enable-pcntl -with-tidy  \
 --enable-shmop --enable-opcache --with-freetype --with-zlib --enable-apcu --enable-ast --enable-brotli \
 --disable-cli --disable-fpm --enable-dba --with-gmp --enable-igbinary --with-imagick --enable-lz4 \
 --enable-memcache --enable-memcached --enable-parallel --enable-protobuf --enable-redis --enable-redis-session \
 --enable-sqlsrv --with-pdo-sqlsrv --with-ssh2 --with-xlswriter --with-xz --with-yaml --enable-zstd --with-libzstd 

make -j3



