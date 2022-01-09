#!/bin/bash
#sudo?
echo "pwd: `pwd`" | tee result.yml
if [ "$EUID" -ne 0 ]; then echo "Error: non root user, use root"; exit 1; fi
#Объем RAM
printf "MemTotal: " | tee -a result.yml
grep MemTotal /proc/meminfo | awk '{print $2}' | tee -a result.yml
#Объем swap
printf "SwapTotal: " | tee -a result.yml
grep SwapTotal /proc/meminfo | awk '{print $2}' | tee -a result.yml
#Объем занятого места
printf "usedSpace: " | tee -a result.yml
df | awk '$6=="/" {print $3}' | tee -a result.yml
#Общее количество пакетов
printf "packetsCount: " | tee -a result.yml
dpkg -l | grep -c '^ii' | tee -a result.yml
#Время обновление дерева пакетов
printf "timeUpdateTree: " | tee -a result.yml
(time apt update 1>&0) 2>&1 | awk '$1=="real" {print $2}' | tee -a result.yml
#Количество и размер обновлений
printf "sizeUpgrade: " | tee -a result.yml
apt dist-upgrade --assume-no | grep -P 'After this' | grep -oP '\d.*B' | tee -a result.yml
#Время обновления установленных пакетов
printf "timeUpgrade: " | tee -a result.yml
(time DEBIAN_FRONTEND=noninteractive apt dist-upgrade -y 1>&0) 2>&1 | awk '$1=="real" {print $2}' | tee -a result.yml
#CPU benchmark
#-r [1-3]: [CPU only, Memory only, All tests] Autorun tests and export scores to [results_cpu.yml, results_memory.yml, results_all.yml]
curl https://www.passmark.com/downloads/pt_linux_x64.zip -o pt_linux_x64.zip
apt install unzip
unzip pt_linux_x64.zip
apt install libncurses5 -y
PerformanceTest/pt_linux_x64 -r 3
cat results_all.yml | grep OSName | tee -a result.yml
cat results_all.yml | grep Kernel | tee -a result.yml
cat results_all.yml | grep Processor | tee -a result.yml
cat results_all.yml | grep NumLogicals | tee -a result.yml
cat results_all.yml | grep Memory | tee -a result.yml
cat results_all.yml | grep NumLogicals | tee -a result.yml
cat results_all.yml | grep SUMM_CPU | tee -a result.yml
cat results_all.yml | grep SUMM_ME | tee -a result.yml
#Время установки докера
printf "timeInstallDocker: " | tee -a result.yml
(time apt install docker docker-compose -y 1>&0) 2>&1 | awk '$1=="real" {print $2}' | tee -a result.yml
#Версия докера
printf "versionDocker: " | tee -a result.yml
docker info |  awk -F ":" '$1==" Server Version" {print $2}' | xargs | xargs | tee -a result.yml
#Spedtest
apt-get install curl
curl -s https://install.speedtest.net/app/cli/install.deb.sh | sudo bash
apt-get install speedtest
speedtest --accept-license --accept-gdpr | tee -a result.yml
speedtest -s 2706 | tee -a result.yml

