#!/bin/bash
#05/01/2023
#Scipt for download a youtube video since a url
if [ ! -d "/srv/yt/downloads" ]; then
  echo "Dossier de destination introuvable. Arrêt du script."
  exit 1
fi

url="${1}"
log="/var/log/yt/download.log"
name="$(youtube-dl --get-filename -o "%(title)s" "${url}")"
path="/srv/yt/downloads/${name}"
mkdir "${path}"



youtube-dl -qo  "${path}/${name}.mp4" "${url}" &> /dev/null
youtube-dl --get-description "${url}" > "/srv/yt/downloads/${name}/desciption" & 2> /dev/null

date="$(echo "[$(date +%Y/%m/%d\ %H:%M:%S)]")"
echo "${date} Video ${url} was downloaded. File path : ${path}/${name}.mp4" &> "${log}"
echo "Video ${url} was downloaded."
echo "File path : ${path}/${name}.mp4"
