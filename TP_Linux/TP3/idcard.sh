#!/bin/bash
#03/01/2023
#Id Card for PC

Name="$(hostnamectl | head -n 2 | tail -n 1 | cut -d ':' -f2)"
echo "Machine Name :${Name}"

os_name="$(cat /etc/redhat-release)"
os_version="$(uname -ar)"
echo "OS ${os_name} and kernel version is ${os_version}"

echo "IP : $(ip a | grep inet | head -n 3 | tail -n 1 | tr -s ' ' | cut -d ' ' -f3)"

mem_free="$(free -h | grep Mem | tr -s ' ' | cut -d ' ' -f4)"
mem_total="$(free -h | grep Mem | tr -s ' ' | cut -d ' ' -f2)"

echo "RAM : ${mem_free} memory available on ${mem_total} total memory"

disk=$(df -h | grep '/$' | tr -s ' ' | cut -d ' ' -f2)
echo "Disk : ${disk} space left"

echo "Top 5 processes by RAM usage :"
ps_result="$(ps -e -o cmd= --sort=-%mem | head -n5 | cut -d' ' -f1)"
while read line
do
echo "- $line"
done <<< "${ps_result}"

echo "Listening ports :"
ports="$(sudo ss -alnp4 | tr -s ' ' | cut -d ':' -f2 | cut -d ' ' -f1)"
name_port="$(sudo ss -alnp4 | tr -s ' ' | cut -d ':' -f4 | cut -d '"' -f2)"