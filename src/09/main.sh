#!/bin/bash
sudo apt install nginx-light
sudo cp ./nginx/nginx.conf /etc/nginx/nginx.conf
sudo nginx -s reload
sudo cp prometheus.yml /etc/prometheus/prometheus.yml
systemctl restart prometheus.service
chmod +x my_nodes.sh
while sleep 3
do
    ./my_nodes.sh > ./nginx/metrics
done
