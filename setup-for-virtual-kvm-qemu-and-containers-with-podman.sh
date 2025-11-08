#!/bin/bash

apt -y install firmware-linux-nonfree firmware-realtek

##https://milkv.io/docs/megrez/development-guide/kvm
## its not active default
modprobe kvm

apt -y  install cockpit bridge-utils cockpit-machines cockpit-podman realmd sscg u-boot-qemu qemu-efi-riscv64 


## use virt manager to create VM of RISC-V Linux with u-boot guide given in milkv website.
#latter you can manage it via cockpit VM
## while podman container are easier to manage

