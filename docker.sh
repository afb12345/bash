apt-get install wget curl dbus apt-transport-https ca-certificates -y
curl -fsSL get.docker.com | sh
apt-get install docker-compose
systemctl enable docker
systemctl start docker
