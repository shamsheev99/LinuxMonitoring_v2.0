#!/bin/bash
#install prometheus
VERSION="2.35.0"
groupadd --system prometheus
useradd --system -g prometheus -s /bin/false prometheus
#apt install -y wget tar
wget https://github.com/prometheus/prometheus/releases/download/v2.35.0/prometheus-2.35.0.linux-amd64.tar.gz -O - | tar -xzv -C ./
mkdir /etc/prometheus
mkdir /var/lib/prometheus
cp prometheus-2.35.0.linux-amd64/prometheus /usr/local/bin
cp prometheus-2.35.0.linux-amd64/promtool /usr/local/bin
cp -r prometheus-2.35.0.linux-amd64/consoles /etc/prometheus
cp -r prometheus-2.35.0.linux-amd64/console_libraries /etc/prometheus
rm -rf /tmp/prometheus-2.35.0.linux-amd64
cp prometheus.yml /etc/prometheus/prometheus.yml 
chown -R prometheus:prometheus /var/lib/prometheus /etc/prometheus
chown prometheus:prometheus /usr/local/bin/prometheus /usr/local/bin/promtool
cp prometheus.service  /etc/systemd/system/prometheus.service 
systemctl daemon-reload
systemctl start prometheus.service
systemctl enable prometheus.service
#install node_exporter
VERSION="1.3.1"
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz -O - | tar -xzv -C ./
cp node_exporter-1.3.1.linux-amd64/node_exporter /usr/local/bin
chown -R prometheus:prometheus /usr/local/bin/node_exporter
cp node_exporter.service /etc/systemd/system/node_exporter.service
systemctl daemon-reload
systemctl start node_exporter.service
systemctl enable node_exporter.service
#install grafana
apt-get install -y software-properties-common wget apt-transport-https
wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
apt-get update && apt-get -y install grafana
cp prometheus2.yml /etc/grafana/provisioning/datasources/prometheus.yml 
chown grafana:grafana /etc/grafana/provisioning/datasources/prometheus.yml
systemctl start grafana-server.service
systemctl enable grafana-server.service
sudo rm -rf node_exporter-1.3.1.linux-amd64 prometheus-2.35.0.linux-amd64