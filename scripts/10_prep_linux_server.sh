#!/bin/bash

sudo apt update ; sudo apt upgrade -y
sudo apt install -y python3-pip python3-venv git htop gcc

pip3 install wheel cython

sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker

sudo groupadd docker
sudo usermod -aG docker $USER
sudo service docker restart



