# 🚀 Add-On Setup and Notes on Work Carried Out on the RISC-V Board (Milk-V Megrez 32GB)

This repository details the configuration and customization steps for the **Milk-V Megrez 32GB RISC-V board** running **RockOS (Debian 13)**. The scripts included here transform the base image into a robust development environment focused on **NPU acceleration**, **LLM deployment**, and **virtualization**.

---

## ✨ Getting Started

1.  **Image Preparation:** Download the RockOS SD Card Image (Debian 13) and burn it to your SATA SSD or MicroSD card.
2.  **Clone Repository:** After booting the board, install Git and clone this repository:
    ```bash
    apt-get -y install git
    cd /opt/
    git clone https://github.com/deependhulla/addon-on-riscv-board-milkv-megrez
    ```
3.  **Execution Order:** Run the setup scripts sequentially as the root user. A **reboot** is required after the first script.
    ```bash
    cd /opt/addon-on-riscv-board-milkv-megrez
    bash 01-basic-repo-and-locale-setup-and-reboot.sh
    # >>> REBOOT REQUIRED HERE <<<
    bash 02-all-eswin-es-sdk-pacakges-setup.sh
    # Continue with optional setup scripts ( ollama, qwen, kvm)
    ```

---

## 🛠️ Scripts and Key Customizations

The following table summarizes the purpose and the most important customizations performed by each setup script.

| Script Filename | Core Functionality | Key Customizations and Features |
| :--- | :--- | :--- |
| **`01-basic-repo-and-locale-setup-and-reboot.sh`** | **Base System Setup & Hardening** | Full system upgrade, installation of essential tools (Vim, tmux), timezone set to **Asia/Kolkata (IST)**, persistent **IPv6 disablement**, system-wide bash aliases (`ll`, `rm -i`), and Python Virtual Environment (`/opt/venv`) creation. |
| **`02-all-eswin-es-sdk-pacakges-setup.sh`** | **NPU Development Environment** | Installs all required **`es-sdk-*`** packages and libraries. This enables the use of the on-board **Eswin NPU** for AI/ML acceleration. |
| **`ollama-for-riscv.sh`** | **Local LLM Deployment (Ollama)** | Clones and **builds the Ollama service** specifically for RISC-V, installs the systemd unit, starts the service, and pulls lightweight models (`smollm:135m`, `granite4:350m`) for immediate testing. |
| **`qwen-model-download-and-testing.sh`** | **NPU-Optimized LLM Setup** | Installs `modelscope`, downloads the **Qwen2-0.5B model** optimized for the **Eswin NPU (ENNP)**, organizes files for the Eswin sample structure, and executes the NPU CLI tool for testing. |
| **`setup-for-virtual-kvm-qemu-and-containers-with-podman.sh`** | **Virtualization & Containerization** | Activates the **KVM** kernel module, installs **QEMU**, **Podman** (daemonless containers), **LXC**, and management interfaces like **Cockpit** (web interface) and **virt-manager** (GUI). |

---

## 🧠 Key Development Areas

### 1. NPU Acceleration
The focus is on leveraging the Eswin NPU. Scripts ensure the necessary SDKs are installed and demonstrate the deployment of a **quantized LLM (Qwen2-0.5B)**, highlighting the board's capability for accelerated AI workloads.

### 2. General-Purpose Computing
The setup includes modern utilities and configurations to support diverse development tasks:
* **Go** and **build-essential** for compiling applications.
* **Python Virtual Environment** to manage project dependencies cleanly.
* **Chronyd** for reliable time synchronization.

### 3. Server Management
The installation of **Cockpit** provides a user-friendly, web-based interface (accessible on **port 9090**) to manage system services, users, storage, and both **VMs (Cockpit Machines)** and **Containers (Cockpit Podman)**. This simplifies remote administration.

---

## 🔗 References

* **RockOS Images:** https://fast-mirror.isrc.ac.cn/rockos/images/generic/20250630_20250818/sdcard-rockos-20250818-234921.img.zst
* **MilkV Megrez Development Guide:** https://milkv.io/docs/megrez/development-guide/ENNP-SDK/yolov3
