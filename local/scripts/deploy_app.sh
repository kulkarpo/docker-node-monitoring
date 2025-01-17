#!/bin/sh
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
apt-get update
apt-get install -y docker-ce
FILE="/etc/docker/daemon.json"
/bin/cat <<EOM >$FILE
{
  "metrics-addr" : "0.0.0.0:9323",
  "experimental" : true
}
EOM
myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo "My Public IP address: ${myip}"
sed -i "s/SERVER_PUBLIC_IP_ADDRESS/$myip/g" ../prometheus/prometheus.yml
sudo service docker restart
curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
cd ..
sudo chmod 777 ./grafana/setup.sh
sudo docker-compose up --build & echo "Alright! we're good now"
#read -p "Press enter to Exit"
