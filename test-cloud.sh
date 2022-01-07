#!/bin/bash
#sudo?
echo "user: $EUID" > result.yml
#if [ "$EUID" -ne 0 ]; then sudo -s; fi
#Объем RAM
printf "MemTotal: " >> result.yml
grep MemTotal /proc/meminfo | awk '{print $2}' >> result.yml
#Объем swap
printf "SwapTotal: " >> result.yml
grep SwapTotal /proc/meminfo | awk '{print $2}' >> result.yml
#Объем занятого места
printf "usedSpace: " >> result.yml
df | awk '$6=="/" {print $3}' >> result.yml
#CPU benchmark
#-r [1-3]: [CPU only, Memory only, All tests] Autorun tests and export scores to [results_cpu.yml, results_memory.yml, results_all.yml]
curl https://www.passmark.com/downloads/pt_linux_x64.zip -o pt_linux_x64.zip
apt install unzip
unzip pt_linux_x64.zip -y
apt install libncurses5 -y
PerformanceTest/pt_linux_x64 -r 3
cat results_all.yml | grep OSName >> result.yml
cat results_all.yml | grep Kernel >> result.yml
cat results_all.yml | grep Processor >> result.yml
cat results_all.yml | grep NumLogicals >> result.yml
cat results_all.yml | grep Memory >> result.yml
cat results_all.yml | grep NumLogicals >> result.yml
cat results_all.yml | grep SUMM_CPU >> result.yml
cat results_all.yml | grep SUMM_ME >> result.yml
#Общее количество пакетов
printf "packetsCount: " >> result.yml
dpkg -l | grep -c '^ii' >> result.yml
#Время обновление дерева пакетов
printf "timeUpdateTree: " >> result.yml
(time apt update 1>&0) 2>&1 | awk '$1=="real" {print $2}' >> result.yml
#Количество и размер обновлений
printf "sizeUpgrade: " >> result.yml
apt dist-upgrade --assume-no | grep -P 'After this' | grep -oP '\d.*B' >> result.yml
#Время обновления установленных пакетов
printf "timeUpgrade: " >> result.yml
(time DEBIAN_FRONTEND=noninteractive apt dist-upgrade -y 1>&0) 2>&1 | awk '$1=="real" {print $2}' >> result.yml
#Время установки докера
printf "timeInstallDocker: " >> result.yml
(time apt install docker docker-compose -y 1>&0) 2>&1 | awk '$1=="real" {print $2}' >> result.yml
#Версия докера
printf "versionDocker: " >> result.yml
docker info |  awk -F ":" '$1==" Server Version" {print $2}' | xargs | xargs >> result.yml
