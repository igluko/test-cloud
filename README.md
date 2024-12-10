# test-cloud
It is bunch of scripts for test new cloud VM purpose

```bash
 curl -sSL https://raw.githubusercontent.com/igluko/test-cloud/refs/heads/main/test-cloud.sh
```

## Replace Cloud VM to RouterOS

### replace Ubuntu 20.04
```bash
sudo apt update && sudo apt install unzip -y && \
sudo mount -t tmpfs -o size=1G tmpfs /tmp && \
cd /tmp && \
curl -sSL https://download.mikrotik.com/routeros/7.16.2/chr-7.16.2.img.zip -o chr.img.zip && \
unzip -o chr.img.zip && \
sudo echo u > /proc/sysrq-trigger && \
sudo dd if=$(find /tmp -name "*.img" | head -n 1) \
of="$(lsblk -no pkname "$(findmnt / -o SOURCE -n)" | awk '{print "/dev/" $1}')" \
bs=4M oflag=sync && \
sync && \
sudo echo 1 > /proc/sys/kernel/sysrq && \
sudo echo b > /proc/sysrq-trigger
```

