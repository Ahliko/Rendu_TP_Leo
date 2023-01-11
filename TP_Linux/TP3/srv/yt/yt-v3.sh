#!/bin/bash
#12/01/2023
#------------------------------------------------
# Created by : Killian Guillemot
#------------------------------------------------
#Script for download a youtube video since a url [!!!!!! BONUS !!!!!!!]

download-yt() {

    log="/var/log/yt/download.log"
    name="$(youtube-dl --get-filename -o "%(title)s" "${url}")"
    path="${path}/${name}"
    if [[ -d ${path} ]]; then
        echo "Already download at : ${path}"
        return
    else
         mkdir "${path}"
    fi

    youtube-dl -f "bestvideo[height<=${quality}]+bestaudio/best[height<=${quality}]" -qo  "${path}/${name}.mp4" "${url}" &> /dev/null
    youtube-dl --get-description "${url}" > "${path}/desciption" 2> /dev/null

    date="[$(date +%Y/%m/%d\ %H:%M:%S)]"
    echo "${date} Video ${url} was downloaded. File path : ${path}/${name}.mp4" >> "${log}"
    echo "Video ${url} was downloaded."
    echo "File path : ${path}/${name}.mp4"
}


usage() {

    echo "Help !"
    echo ""

    echo "Usage of the yt command : "
    echo "  yt.sh [Option] url"

    echo ""
    echo "Option : "

    echo "  -h Print the help."

    echo "  -o Precise what destination folder for the download video."

    echo "  -q Change the quality of the video"
    echo "      Specify  ffmpeg/avconv audio quality, insert a value between 0 (better) and 9 (worse) for VBR or a spe‐
              cific bitrate like 128K (default 5)"
    exit 1
}

if ! command -v youtube-dl > /dev/null; then
    echo "Error: la commande youtube-dl n'est pas installée."
    exit 1
fi
j=0
for i in "${@:1:8}" ; do
    j=$((j+1))
    var["${j}"]="${i}"
done

j=0
for i in "${@:1:8}" ; do
    j=$((j+1))
    if echo "${i}" | grep ^"-o" &> /dev/null; then
        path="${var[${j}+1]}"
        if [ ! -d "${path}" ]; then
            echo "The path doesn't exist"
            usage
        fi
        if [[ ! -w ${path} ]]; then
            echo "You don't have permission to write in this folder"
            exit 1
        fi
    fi
    if echo "${i}" | grep ^"-q" &> /dev/null ; then
        quality="${var[${j}+1]}"
        if [[ "${quality}" -lt 0 ]]; then
            echo "Quality is too sad"
            usage
        fi
    fi
    if echo "${i}" | grep -q ^"https://www.youtube.com" &> /dev/null; then
        url="${var[${j}]}"
    fi
    if echo "${i}" | grep ^"-h" &> /dev/null; then
        usage
    fi
done

if [[ ${url} == "" ]]; then
    echo "You don't give a good url"
    usage
fi
if [[ ${quality} == "" ]]; then
    quality=720
fi
if [[ ${path} == "" ]]; then
    path="/srv/yt/downloads"
fi

download-yt
