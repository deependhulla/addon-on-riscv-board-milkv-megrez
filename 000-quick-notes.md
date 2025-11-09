## Download the SD Card Image of RockOS (Debian 13) for the Milkv Megrez Board

https://fast-mirror.isrc.ac.cn/rockos/images/generic/20250630_20250818/sdcard-rockos-20250818-234921.img.zst

**Uncompress** and **burn** it to a blank **SATA SSD** to boot with the **SATA SSD** on **Milkv Megrez**.
* It also **works** with a **MicroSD** card.
* I used a **128GB SSD**.

**Install** the `git` and `vim` packages to download this **repo** and work with **Vim**.

```bash
apt-get -y install vim git
cd /opt/
git clone https://github.com/deependhulla/addon-on-riscv-board-milkv-megrez
```




