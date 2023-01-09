#!/bin/bash
#05/01/2023
#Scipt for download a youtube video since a url

download-yt() {
    url="${1}"
    log="/var/log/yt/download.log"
    name="$(youtube-dl --get-filename -o "%(title)s" "${url}")"
    path="/srv/yt/downloads/${name}"
    err=""
    if [[ -d ${path} ]]; then
        echo "Already download at : ${path}"
        return
    else
         mkdir "${path}"
    fi

    youtube-dl -qo  "${path}/${name}.mp4" "${url}" &> /dev/null
    youtube-dl --get-description "${url}" > "${path}/desciption" & 2> /dev/null

    date="$(echo "[$(date +%Y/%m/%d\ %H:%M:%S)]")"
    echo "${date} Video ${url} was downloaded. File path : ${path}/${name}.mp4" >> "${log}"
    echo "Video ${url} was downloaded."
    echo "File path : ${path}/${name}.mp4"
}

i=1
if [ ! -d "/srv/yt/downloads" ]; then
    echo "Dossier de destination introuvable. Arrêt du script."
    exit 1
fi
while :
do
file="/srv/yt/list_url.txt"
    while read line
    do
        if [[ -z ${line} ]]; then
        echo "lol" &> /dev/null
        else
            download-yt ${line}
            sed -i '1d' ${file}
        fi
    sleep 10
    done <<< $(cat "${file}")
done
