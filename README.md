# test-cloud
It is bunch of scripts for test new cloud VM purpose

```bash
 curl -sSL https://raw.githubusercontent.com/igluko/test-cloud/refs/heads/main/test-cloud.sh
```

Intsall RouterOS to cloud VM

```bash
sudo mount -t tmpfs -o size=1G tmpfs /tmp && \
cd /tmp && \
curl -sSL https://download.mikrotik.com/routeros/7.16.2/chr-7.16.2.img.zip -o chr.img.zip && \
unzip -o chr.img.zip && \
sudo dd if=$(find /tmp -name "*.img" | head -n 1) of=/dev/vda bs=4M conv=fsync && \
sync && \
echo "Operation complete. /tmp remains mounted in RAM."
```
