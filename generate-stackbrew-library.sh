#!/bin/bash
set -e

cd "$(dirname "$(readlink -f "$BASH_SOURCE")")"

url='https://github.com/kellis5137/Docker.Official.Image.git'

commit="$(git log -1 --format='format:%H' -- Dockerfile $(awk 'toupper($1) == "COPY" { for (i = 2; i < NF; i++) { print $i } }' Dockerfile))"
fullVersion="$(grep -m1 'ENV RC_VERSION ' ./Dockerfile | cut -d' ' -f3)"

cat <<EOF
Maintainers: kellis5137 Image Master <kellis5137@gmail.com> (@kellis5137)
GitRepo: $url

Tags: $fullVersion, ${fullVersion%.*}, ${fullVersion%.*.*}, latest
GitCommit: $commit
EOF
