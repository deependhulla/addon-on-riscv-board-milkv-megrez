#!/bin/bash
# Script: frankenphp-build.sh
# Purpose: Compiles the FrankenPHP server (Caddy + PHP) from source for the RISC-V architecture.
#          This process requires compiling PHP first, then using xcaddy to link PHP and Go.
# Reference: https://frankenphp.dev/docs/compile/

## 1. Install Dependencies
############################################################

# Install essential build tools, libraries, and development headers required for
# compiling both PHP and its various extensions (e.g., cURL, OpenSSL, MySQL, Zip, Intl).

apt-get install re2c libtool pkg-config automake autoconf libxml2-dev libjpeg-dev libpng-dev libwebp-dev libcurl4-openssl-dev libssl-dev libmcrypt-dev mcrypt libmysqlclient-dev libsqlite3-dev libpq-dev autopoint debhelper dh-autoreconf dh-strip-nondeterminism dwz gettext intltool-debian libarchive-cpio-perl libarchive-zip-perl libdebhelper-perl libfile-stripnondeterminism-perl libmail-sendmail-perl libpcre2-32-0 libpcre2-dev libpcre2-posix3 libsys-hostname-long-perl shtool brotli  libbrotli-dev libonig-dev libbison-dev bison brotli-rs  libbrotli-dev golang-github-andybalholm-brotli-dev libbrotli1 libbz2-dev libgmp-dev libzip-dev libzip-dev libwebp-dev libjpeg-dev libpng-dev libfreetype-dev libicu-dev libgettextpo-dev libldap2-dev libpq-dev libtidy-dev libxslt-dev libsnmp-dev libsodium-dev gettext libffi-dev


## 2. Compile and Install watcher-c Library
############################################################
# Download the watcher repository, which contains the watcher-c library (used for filesystem watching).
cd /opt/
curl -L https://github.com/e-dant/watcher/archive/refs/heads/next.tar.gz | tar xz
# Navigate into the C language binding directory.
cd watcher-next/watcher-c
# Compile the watcher-c library into a shared object (.so file).
# Uses C++17 standard and position-independent code (fPIC).
c++ -o libwatcher-c.so ./src/watcher-c.cpp -I ./include -I ../include -std=c++17 -fPIC -shared
# Install the compiled shared library to the system path.
cp libwatcher-c.so /usr/local/lib/libwatcher-c.so
# Update the dynamic linker run-time bindings.
ldconfig
# Copy the watcher header files to the standard system include path.
cp -pRv /opt/watcher-next/watcher-c/include/wtr /usr/include/

## 3. Download Build Tools and Source Code
############################################################

# Return to the /opt directory.
cd /opt/
# Download and install xcaddy, the tool used to build customized Caddy/FrankenPHP binaries.
wget -c https://github.com/caddyserver/xcaddy/releases/download/v0.4.5/xcaddy_0.4.5_linux_riscv64.deb
dpkg -i xcaddy_0.4.5_linux_riscv64.deb

# Download and extract the Go compiler for RISC-V.
wget -c https://go.dev/dl/go1.25.4.linux-riscv64.tar.gz
tar -xzf go1.25.4.linux-riscv64.tar.gz

# Download and extract the PHP source code.
wget -c https://www.php.net/distributions/php-8.4.14.tar.gz
tar -xzf php-8.4.14.tar.gz

# Clone the FrankenPHP repository.
git clone https://github.com/php/frankenphp

# Add the downloaded Go binary path to the system PATH environment variable.
export PATH=/opt/go/bin/:/usr/local/bin:$PATH

## 4. Compile and Install PHP
############################################################

# Navigate into the PHP source directory.
cd /opt/php-8.4.14
# Configure PHP compilation with necessary flags for embedding and extensions.
# --enable-embed and --enable-zts are critical for FrankenPHP integration.
./configure --enable-embed --enable-zts --disable-zend-signals --enable-zend-max-execution-timers \
 --with-config-file-path=/etc --with-zlib --with-openssl --with-curl --with-pdo-mysql=mysqlnd \
 --enable-mbstring --enable-soap --enable-sockets --enable-bcmath --with-bz2 \
 --enable-calendar --enable-exif --enable-ftp --with-gmp --enable-shmop \
 --enable-sysvmsg --enable-sysvsem --enable-sysvshm  \
 --enable-pcntl --with-zip --enable-intl --with-gettext --with-ldap \
 --with-pdo-pgsql --with-pgsql --with-tidy --with-xsl --with-snmp --with-sodium --with-ffi

# Compile PHP using all available CPU cores for speed.
make -j"$(getconf _NPROCESSORS_ONLN)"
# Run the PHP test suite (optional but recommended).
make test
# Install the compiled PHP binaries and libraries system-wide.
make install

## 5. Install Composer
############################################################

# Return to the /opt directory.
cd /opt/
# Download the Composer installer script.
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"

# Verify the installer's checksum for integrity and security.
php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }"

# Execute the installer.
php composer-setup.php

# Clean up the installer script.
php -r "unlink('composer-setup.php');"

# Move the Composer Phar archive to a location in the system PATH.
mv composer.phar /usr/local/bin/composer

## 6. Build FrankenPHP
############################################################

# Navigate to the FrankenPHP source directory.
cd /opt/frankenphp
# Build FrankenPHP using xcaddy, linking it with the custom-compiled PHP.
# CGO_ENABLED=1: Enables CGO for linking C libraries (PHP).
# XCADDY_GO_BUILD_FLAGS: Sets Go linker flags and build tags to reduce binary size and exclude unnecessary modules.
# CGO_CFLAGS/CGO_LDFLAGS: Provide PHP's include paths and linker flags to xcaddy.

CGO_ENABLED=1 \
CGO_ENABLED=1 \
XCADDY_GO_BUILD_FLAGS="-ldflags='-w -s' -tags=nobadger,nomysql,nopgx,nobrotli,nowatcher" \
CGO_CFLAGS=$(php-config --includes) \
CGO_LDFLAGS="$(php-config --ldflags) $(php-config --libs)" \
xcaddy build \
    --output frankenphp \
    --with github.com/dunglas/frankenphp/caddy \
    --with github.com/dunglas/mercure/caddy \
    --with github.com/dunglas/vulcain/caddy \

## 7. Test and Run
############################################################

# Create a simple test file to verify PHP is working.
echo "<?php phpinfo(); ?>" >  /opt/frankenphp/index.php

# Execute the built FrankenPHP server in PHP-server mode.
/opt/frankenphp/frankenphp php-server 

#Open Broswer to port 80 to check

