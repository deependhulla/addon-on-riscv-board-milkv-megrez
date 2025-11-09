#!/bin/bash

# Script: setup-for-virtual-kvm-qemu-and-containers-with-podman.sh
# Purpose: Installs essential virtualization (KVM, QEMU), containerization (Podman, LXC),
#          and management tools (Cockpit, virt-manager) to enable running VMs and containers
#          on the RISC-V board.

## 1. Preparation and Core KVM Activation
############################################################

# Comment clarifying the goal of the script: to set up LXC, VM, and Podman containers.
## let get LXC, VM, Podman -Contianer up on this PC.

# NOTE: This section is commented out but provides a suggestion for fixing common hardware issues.
# Uncomment these lines if you encounter excessive firmware errors during installation or boot,
# as they install non-free and Realtek-specific firmware packages often required by certain hardware.
## if you get toomany firmare error and want to install
##apt -y install firmware-linux-nonfree firmware-realtek

# Reference the Milkv documentation for the KVM setup guide.
##https://milkv.io/docs/megrez/development-guide/kvm
## its not active default

# Load the Kernel-based Virtual Machine (KVM) module.
# Although KVM support is often present in the kernel, the module must be explicitly
# loaded to be active and usable by virtualization tools like QEMU.

modprobe kvm

## 2. Install Virtualization and Management Packages
############################################################

# Install a comprehensive suite of packages for virtualization and management:
# - cockpit: Web-based server administration interface.
# - bridge-utils: Utilities for creating and managing network bridges (essential for VMs/containers).
# - cockpit-machines: Cockpit plugin for managing VMs (via libvirt).
# - cockpit-podman: Cockpit plugin for managing Podman containers.
# - realmd, sscg: Tools related to domain membership and security (often useful in server environments).
# - u-boot-qemu, qemu-efi-riscv64: QEMU components necessary for RISC-V virtualization boot.
# - virt-manager: Graphical desktop application for managing VMs (requires X-forwarding or desktop access).
# - lxc: Linux Containers user-space tools.

apt -y  install cockpit bridge-utils cockpit-machines cockpit-podman realmd sscg u-boot-qemu qemu-efi-riscv64 virt-manager lxc podman podman-compose 


## 3. Usage Notes
############################################################

# Note on VM creation: Use the virt-manager GUI tool to create the initial RISC-V Linux VM.
# Follow the u-boot guide provided on the Milkv website for the specific boot requirements.
## use virt manager to create VM of RISC-V Linux with u-boot guide given in milkv website.

# Note on Management: After initial creation, VMs can be conveniently managed via the
# web-based Cockpit interface (Cockpit Machines plugin). Podman containers are generally simpler to manage.

