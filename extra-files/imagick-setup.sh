#!/bin/bash

cd /opt/
wget https://github.com/ImageMagick/ImageMagick/archive/refs/tags/7.1.2-8.tar.gz
git clone https://github.com/Imagick/imagick
cd imagick
phpize && ./configure
make
make install
