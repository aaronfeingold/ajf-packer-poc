#!/bin/bash
set -e

sudo dnf update -y
sudo dnf install -y git ansible python3 python3-pip
mkdir -p ~/ansible-playbooks
