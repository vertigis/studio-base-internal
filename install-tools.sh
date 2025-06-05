#!/bin/bash
set -e

mkdir -p .tmp
apt -y update
apt -y upgrade
apt -y install certbot gh nano python3 python3-aiohttp

if ! which docker > /dev/null; then
  curl -fsSL https://get.docker.com -o .tmp/get-docker.sh
  bash ./.tmp/get-docker.sh
fi

rm -rf .tmp
usermod -aG docker $SUDO_USER
