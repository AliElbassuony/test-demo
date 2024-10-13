#!/bin/bash

sudo apt update -y
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible -y
sudo apt install ansible -y
sudo apt install python3-pip -y
pip3 install boto3 --break-system-packages
ansible-galaxy collection install community.aws