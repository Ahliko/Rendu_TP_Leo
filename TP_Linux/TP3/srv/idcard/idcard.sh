#!/bin/bash
#03/01/2023
#Id Card for PC

download_picture () {
  image_url="https://cataas.com/cat"
  destination_folder="./"
  sudo wget "$image_url" -P "$destination_folder" &> /dev/null
  image_file=$(basename "$image_url")
  file_extension=$(file --extension "$image_file" | cut -d ' ' -f2 | cut -d '/' -f1)
  echo ""
  echo "Here is your random cat : ${destination_folder}${image_file}.${file_extension}"
}


Name="$(hostnamectl | head -n 2 | tail -n 1 | cut -d ':' -f2)"
echo "Machine Name :${Name}"

os_name="$(cat /etc/redhat-release)"
echo "OS ${os_name} and kernel version is $(uname -ar | awk '{print $1}') $(uname -ar | awk '{print $2}') $(uname -ar | awk '{print $3}')"

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
  echo "  - ${line}"
done <<< "${ps_result}"

echo "Listening ports :"
while read line
do
  port=$(echo "${line}" | awk '{print $5}' | cut -d ':' -f2)
  protocol=$(echo "${line}" | awk '{print $1}')
  name_service=$(echo "${line}" | awk '{print $7}' | cut -d '"' -f2)

  if [[ "Local" -ne ${port} ]]; then
    echo "  - ${port} ${protocol} : ${name_service}"
  fi
done <<< "$(sudo ss -alnp4 | tr -s ' ')"

download_picture