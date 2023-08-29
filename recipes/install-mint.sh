#Install docker
sudo apt-get remove docker docker-engine docker.io
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"
sudo apt-get update
sudo apt-get install -y docker-ce
sudo apt-get install -y docker-compose

#Install ansible
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible

#Install make
sudo apt-get install -y make

#Install unzip
apt-get install -y zip
apt-get install -y unzip