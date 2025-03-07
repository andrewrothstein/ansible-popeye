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
    printf "    %s: sha256:%s\n" $platform $(grep -e "$file\$" $lchecksums | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    # https://github.com/derailed/popeye/releases/download/v0.10.0/checksums.sha256
    local url="${MIRROR}/v${ver}/checksums.sha256"
    local lchecksums="$DIR/${APP}_${ver}_checksums.sha256"
    if [ ! -e $lchecksums ];
    then
        curl -sSLf -o $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver

    dl $ver $lchecksums darwin arm64
    dl $ver $lchecksums darwin amd64
    dl $ver $lchecksums linux arm64
    dl $ver $lchecksums linux amd64
    dl $ver $lchecksums windows arm64
    dl $ver $lchecksums windows amd64
}

dl_ver ${1:-0.22.1}
