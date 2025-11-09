# 📝 Notes on Device Tree Blob (DTB) Modifications for RockOS

This document details the process for inspecting and modifying the Device Tree Blob (DTB) on the **Milk-V Megrez** board running **RockOS** (Kernel `6.6.88-win2030`). This modification is critical for **reallocating RAM** between the **Linux Operating System (OS)** and the **Eswin Neural Processing Unit (NPU)**.

---

## 💾 Image Source and DTB Inspection

### 1. Source Image

The foundation for this work is the official RockOS image:

* **Download SD Card Image of RockOS (Debian 13) for the Milkv Megrez Board:**
    `https://fast-mirror.isrc.ac.cn/rockos/images/generic/20250630_20250818/sdcard-rockos-20250818-234921.img.zst`

### 2. Original DTB Backup and Decompilation

The original DTB, which defines the default RAM split, is copied and then decompiled to its human-readable source code (`.dts`) for inspection.

* **Backup the Original DTB:**
    ```bash
    /bin/cp -pRv /boot/dtbs/linux-image-6.6.88-win2030/eswin/eic7700-milkv-megrez.dtb eic7700-milkv-megrez-orginal-copy-with-25gb-usable-for-os-and7gb-for-npu.dtb
    ```

* **Ensure Compiler is Installed:** (This package was likely installed in `01-basic-repo-and-locale-setup-and-reboot.sh`)
    ```bash
    apt -y install device-tree-compiler
    ```

* **Decompile DTB to DTS (Device Tree Source) for Code Checking:**
    ```bash
    dtc -i dtb -O dts -o eic7700-milkv-megrez-orginal-copy-with-25gb-usable-for-os-and7gb-for-npu.dts eic7700-milkv-megrez-orginal-copy-with-25gb-usable-for-os-and7gb-for-npu.dtb
    ```

### 3. Default RAM Allocation (7GB NPU)

When using the **original DTB** (allocating approximately **7GB** to the NPU), the system memory (as seen by the Linux OS) is:

* **`free -h` Output (Default Allocation):**
    ```
                    total         used         free       shared  buff/cache    available
    Mem:             25Gi        2.4Gi         19Gi         39Mi        4.3Gi         23Gi
    Swap:              0B           0B           0B
    ```

---

## ⚙️ Testing Modified DTBs

The DTB files in this folder contain different RAM split configurations to test the system's performance under various loads.

### Available DTB/DTS Pairs for Testing

| DTB/DTS Filename | OS RAM Usable | NPU RAM Allocated | Purpose / Notes |
| :--- | :--- | :--- | :--- |
| `eic7700-milkv-megrez-orginal-copy-with-25gb-usable-for-os-and7gb-for-npu.dtb` | 25 GiB | 7 GiB | **Original Default** configuration. |
| `eic7700-milkv-megrez-updated-copy-with-12gb-usable-for-os-and20gb-for-npu.dtb` | 12 GiB | 20 GiB | **High NPU Allocation** for large models. |
| `eic7700-milkv-megrez-updated-copy-with-20gb-for-npu-with-desktop-as-cma-512mb.dtb` | ~12 GiB | 20 GiB | **High NPU Allocation**; includes a **512MB CMA** to improve desktop usability (reduces screen flicker). |

### Example Result (After High NPU Allocation)

After applying a DTB that allocates **20GB** to the NPU, the usable system memory (OS) drops, as shown below:

* **`free -h` Output (Example Modified Allocation):**
    ```
                    total         used         free       shared  buff/cache    available
    Mem:             11Gi        1.0Gi         10Gi        2.2Mi        501Mi         10Gi
    Swap:              0B           0B           0B
    ```

---

## ⚠️ Important Usage Warning

**DISCLAIMER:** Please use these modified DTBs **at your own risk**. While they have been validated to work (as the official DTB file sometimes requires adjustment), they alter fundamental hardware configuration.

* **Maximum NPU Allocation Tested:** I have successfully tested a configuration that makes **25GB available to the NPU** for running very large models, such as the **Deepseek model**, as detailed in the official documentation:
    `https://milkv.io/docs/megrez/development-guide/runtime-sample/deepseek-r1`

* **Desktop Usability Note:**
    * One DTS file includes a **512MB Contiguous Memory Allocator (CMA)**, which is necessary to make the desktop environment usable (reducing screen flicker) after booting.
    * The other DTS file uses the **default CMA** setting, which may render the desktop unusable, limiting the device to server-like, command-line interface (CLI) only access for NPU workloads.

---

