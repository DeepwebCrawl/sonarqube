#!/bin/bash
function docker_install() {
    docker_check=$(which docker)
    if [ -z "$docker_check" ]; then
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
    fi
}

function docker_compose_install() {
    docker_compose_check=$(which docker-compose)
    if [ -z "$docker_compose_check" ]; then
        apt install jq -y || yum install jq -y
        compose_version=$(curl https://api.github.com/repos/docker/compose/releases/latest | jq .name -r)
        output='/usr/local/bin/docker-compose'
        curl -L https://github.com/docker/compose/releases/download/$compose_version/docker-compose-$(uname -s)-$(uname -m) -o $output
        chmod +x $output
        
    fi
}

function sonarqube_docker_pull()
{
    docker pull sonarqube:9.5-enterprise
}

function sonarqube_docker_path_file()
{
    mkdir -p /opt/sonarqube/lib
    wget https://github.com/vncloudsco/random/releases/download/v3/sonar-application-9.5.0.56709.jar -O /opt/sonarqube/lib/sonar-application-9.5.0.56709.jar
}

function sonarqube_docker_start()
{
    docker-compose up -d
}

docker_install
docker_compose_install
sonarqube_docker_pull
sonarqube_docker_path_file
sonarqube_docker_start

echo "Install done check sonarqube on http://$(curl -s ifconfig.io):9000"