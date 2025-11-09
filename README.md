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
| **`01-basic-repo-and-locale-setup-and-reboot.sh`** | **Base System Setup ** | Full system upgrade, installation of essential tools (Vim, tmux), timezone set to **Asia/Kolkata (IST)**, persistent **IPv6 disablement**, system-wide bash aliases (`ll`, `rm -i`), and Python Virtual Environment (`/opt/venv`) creation. |
| **`02-all-eswin-es-sdk-pacakges-setup.sh`** | **NPU Development Environment** | Installs all required **`es-sdk-*`** packages and libraries. This enables the use of the on-board **Eswin NPU** for AI/ML acceleration. |
| **`ollama-for-riscv.sh`** | **Local LLM Deployment (Ollama)** | Clones and **builds the Ollama service** specifically for RISC-V, installs the systemd unit, starts the service, and pulls lightweight models (`smollm:135m`, `granite4:350m`) for immediate testing. |
| **`qwen-model-download-and-testing.sh`** | **NPU-Optimized LLM Setup** | Installs `modelscope`, downloads the **Qwen2-0.5B model** optimized for the **Eswin NPU (ENNP)**, organizes files for the Eswin sample structure, and executes the NPU CLI tool for testing. |
| **`setup-for-virtual-kvm-qemu-and-containers-with-podman.sh`** | **Virtualization & Containerization** | Activates the **KVM** kernel module, installs **QEMU**, **Podman** (daemonless containers), **LXC**, and management interfaces like **Cockpit** (web interface) and **virt-manager** (GUI). |
| **`frankenphp-build.sh`** | **Modern PHP/Web Server Build** | **Compiles FrankenPHP** (Caddy + PHP) from source for RISC-V. This enables using PHP in **worker mode** for significantly higher performance than traditional PHP-FPM, along with Caddy's **automatic HTTPS** and **HTTP/3** support. |
---

## 🧠 Key Development Areas


## 1. NPU Acceleration (19.95 TOPS)
The core focus is leveraging the **ESWIN EIC7700X NPU**. Scripts facilitate the installation of the NPU SDK and demonstrate the deployment of a **quantized LLM (Qwen2-0.5B)** for hardware acceleration.

* **RAM Split Customization:** The memory allocation between the OS and NPU can be adjusted using custom **Device Tree Blobs (DTBs)**. Refer to the notes for details on maximizing NPU memory:
    * **DTB Modification Notes:** [`eswin-dtb-and-dts-for-rockos-linux-image-6.6.88-win2030/000-quick-notes.md`](eswin-dtb-and-dts-for-rockos-linux-image-6.6.88-win2030/000-quick-notes.md)

### 2. Modern Web Development with FrankenPHP
The inclusion of **FrankenPHP** (Caddy + Embedded PHP) shifts the board's capability from a traditional PHP-FPM stack to a **single-process, high-performance application server**. This is critical for serving modern PHP frameworks efficiently, offering **persistent PHP workers** and **automatic TLS/HTTP/3** from Caddy.

### 3. General-Purpose & Server Management
The setup ensures readiness for diverse development with tools like **Go**, **build-essential**, and a dedicated **Python Virtual Environment**. The **Cockpit** web interface (on **port 9090**) provides simplified remote management for system services, VMs, and Podman Containers.

---

## 🔗 References

* **RockOS Images:** https://fast-mirror.isrc.ac.cn/rockos/images/generic/20250630_20250818/sdcard-rockos-20250818-234921.img.zst
* **MilkV Megrez Development Guide:** https://milkv.io/docs/megrez/development-guide/ENNP-SDK/yolov3
* **Jeff Geerling Guide to build Ollama on RISC-V** https://www.jeffgeerling.com/blog/2025/how-build-ollama-run-llms-on-risc-v-linux
* **FrankenPHP Docs** https://frankenphp.dev/docs/compile/
