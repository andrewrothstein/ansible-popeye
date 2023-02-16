#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/derailed/popeye/releases/download
APP=popeye

dl() {
    local ver=$1
    local lchecksums=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-tar.gz}
    local platform="${os}_${arch}"
    local file="${APP}_${platform}.${archive_type}"
    local url=$MIRROR/v$ver/$file
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $platform $(grep $file $lchecksums | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    # https://github.com/derailed/popeye/releases/download/v0.10.0/checksums.txt
    local url="${MIRROR}/v${ver}/checksums.txt"
    local lchecksums="$DIR/${APP}_${ver}_checksums.txt"
    if [ ! -e $lchecksums ];
    then
        curl -sSLf -o $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver

    dl $ver $lchecksums Darwin arm64
    dl $ver $lchecksums Darwin x86_64
    dl $ver $lchecksums Linux arm
    dl $ver $lchecksums Linux arm64
    dl $ver $lchecksums Linux x86_64
    dl $ver $lchecksums Windows arm
    dl $ver $lchecksums Windows arm64
    dl $ver $lchecksums Windows x86_64
}

dl_ver ${1:-0.11.0}
