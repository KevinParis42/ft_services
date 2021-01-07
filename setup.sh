#!/bin/bash

printf "=-=-=-=-=-=-=-=- Cleaning Docker and Minishell installs -=-=-=-=-=-=-=-=\n";
service nginx stop
sudo pkill mysql 
sudo apt-get update -y
sudo apt-get -y dist-upgrade
sudo apt-get autoremove -y
sudo apt-get install docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo chown user42:user42 /var/run/docker.sock
sudo rm -rf /usr/local/bin/kubectl
minikube delete 
rm -rf ~/.minikube
sudo rm -rf /usr/local/bin/minikube

printf "\n\n=-=-=-=-=-=-=-=- Testing docker install -=-=-=-=-=-=-=-=\n";
sleep 1
docker ps > /dev/null;

if [[ $? == 1 ]];
then
	printf "Docker ps is not working.
	Updating Docker for the virtual machine.\n";
	sleep 1
	sudo usermod -aG docker $USER;
	printf "Pls, restart virtual machine.\n";
	exit 1;
fi

printf "\n\n=-=-=-=-=-=-=-=- Kubernetes install -=-=-=-=-=-=-=-=\n";
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

printf "\n=-=-=-=-=-=-=-=- Minikube install -=-=-=-=-=-=-=-=\n";
sleep 1
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube && sudo install minikube /usr/local/bin/ && rm minikube

printf "\n=-=-=-=-=-=-=-=- Minikube start with docker driver -=-=-=-=-=-=-=-=\n";
sleep 1
minikube start --driver=docker
printf "\n=-=-=-=-=-=-=-=- Checking Minikube update -=-=-=-=-=-=-=-=\n";
minikube update-check
CLUSTER_IP=$(minikube ip)

printf "\n=-=-=-=-=-=-=-=- Enbale MetalLb -=-=-=-=-=-=-=-=\n";
minikube addons enable metallb

printf "\n=-=-=-=-=-=-=-=- Config Map -=-=-=-=-=-=-=-=\n";
sed -i.bak "s/CLUSTER_IP/"$CLUSTER_IP"/g" srcs/config_map.yml 
kubectl apply -f srcs/config_map.yml
if (cat srcs/config_map.yml.bak > /dev/null) then
rm srcs/config_map.yml && mv srcs/config_map.yml.bak srcs/config_map.yml ;
fi

sed -i.bak "s/CLUSTER_IP/"$CLUSTER_IP"/g" srcs/mysql/wordpress.sql

printf "\n=-=-=-=-=-=-=-=- Link docker with minikube -=-=-=-=-=-=-=-=\n";

eval $(minikube -p minikube docker-env)
docker system prune -f

printf "\n=-=-=-=-=-=-=-=- Service loop -=-=-=-=-=-=-=-=\n";

services="ftps mysql phpmyadmin nginx wordpress influxdb telegraf grafana"

for i in $services
do
	printf "\n\n=-=-=-=-=-=-=-=- $i: -=-=-=-=-=-=-=-=\n\n";
	docker exec -it minikube docker rmi -f $i > /dev/null
	kubectl delete -f ./srcs/yml/$i.yml > /dev/null
	while (kubectl get pods | grep $i > /dev/null) do
		sleep 2;
	done
	docker build -t $i ./srcs/$i/.
	kubectl apply -f ./srcs/yml/$i.yml
done

if (cat srcs/mysql/wordpress.sql.bak > /dev/null) then
rm srcs/mysql/wordpress.sql && mv srcs/mysql/wordpress.sql.bak srcs/mysql/wordpress.sql ;
fi 

printf "\n=-=-=-=-=-=-=-=- END -=-=-=-=-=-=-=-=\n\n"
minikube dashboard