#!/bin/bash

# install docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
sudo apt install docker-ce -y
sudo apt install sshpass -y

# init docker swarm manager01
sudo docker swarm init --advertise-addr 10.11.10.1
TOKEN=`sudo docker swarm join-token worker -q`

# init worker01
sshpass -p vagrant ssh -o StrictHostKeyChecking=no vagrant@10.11.10.2 'sudo docker swarm join --token '$TOKEN' 10.11.10.1:2377'

# init worker02
sshpass -p vagrant ssh -o StrictHostKeyChecking=no vagrant@10.11.10.3 'sudo docker swarm join --token '$TOKEN' 10.11.10.1:2377'

# start-services
sudo docker stack deploy -c docker-compose.yml part3