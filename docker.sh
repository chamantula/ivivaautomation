#!/bin/bash

<< Author
Name : Harish
Version: 1.0
Author

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update


sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose
sudo apt-get install nodejs -y


sudo ./binary.sh
sudo mv /var/data/iviva/Product* /var/data/iviva/apps/
echo 'export PATH="$PATH:/var/data/iviva/sdm"' >> ~/.bash_profile
echo 'export IVIVA_CONFIG_PATH=$HOME/iviva.yml' >> ~/.bash_profile

curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
sudo apt-get update
sudo apt install mssql-tools -y

export PATH="$PATH:/var/data/iviva/sdm"
export IVIVA_CONFIG_PATH="$HOME/iviva.yml"
export PATH="$PATH:/opt/mssql-tools/bin"
sudo docker-compose up -d
ip=$(ip addr show enp0s3 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
sudo sed -i "s/data source = Database/data source = $ip/g" iviva.yml
sqlcmd -S $ip -U SA -P 'Welcome@123' -i $HOME/createDB.sql
/var/data/iviva/sdm/sdm mergedb DB /var/data/iviva/ivivaweb/DB/AccountDB.xml auto
/var/data/iviva/sdm/sdm mergedb MessagingDB /var/data/iviva/ivivaweb/DB/MessagingDB.xml auto
/var/data/iviva/sdm/sdm mergedb JobQueueDB /var/data/iviva/ivivaweb/DB/JobQueueDB.xml auto
/var/data/iviva/sdm/sdm mergedb LucyEventDB /var/data/iviva/ivivaweb/DB/LucyEventDB.xml auto
/var/data/iviva/sdm/sdm mergedb GroupADB /var/data/iviva/ivivaweb/DB/ProcessDB.xml auto
/var/data/iviva/sdm/sdm createaccount eutech 3.1.5.0 
/var/data/iviva/sdm/sdm eutech mergedb auto
/var/data/iviva/sdm/sdm eutech inituserroles all
/var/data/iviva/sdm/sdm eutech installviews all
/var/data/iviva/sdm/sdm eutech listapps
sqlcmd -S $ip -U SA -P 'Welcome@123' -i $HOME/Createdomainmap.sql
cd $HOME/unitfiles
sudo cp -r * /etc/systemd/system/
for i in $(ls); do sudo systemctl enable $i; sudo systemctl start $i;done
sudo systemctl daemon-reload
sudo systemctl enable ivivaweb.service
sudo systemctl start ivivaweb.service

