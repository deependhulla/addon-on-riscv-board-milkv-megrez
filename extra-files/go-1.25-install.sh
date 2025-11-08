#!/bin/sh
cd /opt/
wget -c https://go.dev/dl/go1.25.4.linux-riscv64.tar.gz

export PATH=/opt/go/bin/:$PATH

