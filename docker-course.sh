#!/bin/bash

# This script has only been tested on Trusty ...

# TODO check the user has run the setup script, if not warn them and exit
# TODO make an interactive option for this script requiring the user to hit n for next
# TODO delete all current docker images on this host before proceeding? This could potentially annoy someone

# cat /etc/os-release

EDITOR=/usr/bin/vim
OUR_USER=dojo
DOCKER_AUTHOR="Donovan Jones"
DOCKER_EMAIL="donovan@catalyst.net.nz"
INTERACTIVE=0
function wait_for_keypress {
    if [[ $INTERACTIVE == '1' ]];
    then
        read -n1 -rsp "" key
    fi
    echo
}

# check that these containers don't exist
for container in insane_babbage nostalgic_morse;
do
    #echo checking for $container
    if docker ps -a | grep -q $container
    then
        #echo container $container exists, please remove it before running this script;
        #exit;
        docker rm $(sudo docker ps -a -q)
    fi
done

# https://docs.docker.com/userguide/dockerizing/
echo -----------------------------------------------------------------
echo -n "# https://docs.docker.com/userguide/dockerizing/"
wait_for_keypress;

# Hello world
echo --------------------------------01: Hello world---------------------------------
echo -n "# sudo docker run ubuntu:14.04 /bin/echo 'Hello world'"
wait_for_keypress;

docker run ubuntu:14.04 /bin/echo 'Hello world'

# An interactive container
# -i, --interactive=false    Keep STDIN open even if not attached
# -t, --tty=false            Allocate a pseudo-TTY
echo --------------------------------02: An interactive container---------------------------------
echo "# sudo docker run -t -i ubuntu:14.04 /bin/bash"
echo -n "# type exit when you are done looking around"
wait_for_keypress;
if [[ $INTERACTIVE == '1' ]];
then
    docker run -t -i ubuntu:14.04 /bin/bash
fi

# A daemonized Hello world
echo --------------------------------03: A daemonized Hello world---------------------------------
echo -n '# sudo docker run --name=insane_babbage -d ubuntu:14.04 /bin/sh -c "while true; do echo hello world; sleep 1; done"'
wait_for_keypress;

# Note the use of --name=insane_babbage which gives us a consistent name
# TODO: check we are not already running insane_babbage before running this
docker run --name=insane_babbage -d ubuntu:14.04 /bin/sh -c "while true; do echo hello world; sleep 1; done"

echo -n '# sudo docker ps'
wait_for_keypress;
docker ps

echo -n '# sudo docker logs insane_babbage'
wait_for_keypress;
docker logs insane_babbage | tail -n 10

echo -n '# sudo docker stop insane_babbage'
wait_for_keypress;
docker stop insane_babbage

echo -n '# sudo docker ps'
wait_for_keypress;
docker ps

# https://docs.docker.com/userguide/usingdocker/
echo -----------------------------------------------------------------
echo -n "# https://docs.docker.com/userguide/usingdocker/"
wait_for_keypress;

# Working with containers
echo --------------------------------01: Working with containers---------------------------------
echo -n "# sudo docker version"
wait_for_keypress;
docker version

# Get Docker command help
echo --------------------------------02: Get Docker command help---------------------------------
echo -n "# docker --help"
wait_for_keypress;
docker --help
echo -n "# docker attach --help"
wait_for_keypress;
docker attach --help

# Running a web application in Docker
echo --------------------------------03: Running a web application in Docker---------------------------------
# Note the use of --name=nostalgic_morse which gives us a consistent name
# -P, --publish-all=false    Publish all exposed ports to random ports
echo -n '# sudo docker run --name=nostalgic_morse -d -P training/webapp python app.py'
wait_for_keypress;
docker run --name=nostalgic_morse -d -P training/webapp python app.py

# Viewing our web application container
echo --------------------------------04: Viewing our web application container---------------------------------
echo '# sudo docker ps -l'
wait_for_keypress;
docker ps -l

# A network port shortcut
echo --------------------------------05: A network port shortcut---------------------------------
echo -n "# sudo docker port nostalgic_morse 5000"
wait_for_keypress;
docker port nostalgic_morse 5000

# 0.0.0.0, in this context, means "all IPv4 addresses on the local machine"
# Lets take a closer look:
echo -n "# curl -s -i http://\$( sudo docker port nostalgic_morse 5000 )/"
wait_for_keypress;
curl -s -i http://$( docker port nostalgic_morse 5000 )/
echo

echo -n "# sudo lsof -i | egrep 'docker|COMMAND'"
wait_for_keypress;
lsof -i | egrep 'docker|COMMAND'

# Viewing the web application’s logs
echo --------------------------------06: Viewing the web application’s logs---------------------------------
echo -n "# sudo docker logs -f nostalgic_morse"
echo -n "# hit CTRL-C to exit"
wait_for_keypress;
if [[ $INTERACTIVE == '1' ]];
then
    docker logs -f nostalgic_morse
fi

# Looking at our web application container’s processes
echo --------------------------------07: Looking at our web application container’s processes---------------------------------
echo -n "# sudo docker top nostalgic_morse"
wait_for_keypress;
docker top nostalgic_morse

# Inspecting our web application container
echo --------------------------------08: Inspecting our web application container---------------------------------
echo -n "# sudo docker inspect nostalgic_morse"
wait_for_keypress;
docker inspect nostalgic_morse

echo -n "# docker inspect -f '{{ .NetworkSettings.IPAddress }}' nostalgic_morse"
wait_for_keypress;
docker inspect -f '{{ .NetworkSettings.IPAddress }}' nostalgic_morse

# Stopping our web application container
echo --------------------------------09: Stopping our web application container---------------------------------
echo -n "# sudo docker stop nostalgic_morse"
wait_for_keypress;
docker stop nostalgic_morse

echo -n "# sudo docker ps -l"
wait_for_keypress;
docker ps -l

# Restarting our web application container
echo --------------------------------10: Restarting our web application container---------------------------------
echo -n "# sudo docker start nostalgic_morse"
wait_for_keypress;
docker start nostalgic_morse

echo -n "# sudo docker ps -l"
wait_for_keypress;
docker ps -l

# also 'sudo docker restart nostalgic_morse'

# Removing our web application container
echo --------------------------------11: Removing our web application container---------------------------------
echo -n "# sudo docker rm nostalgic_morse"
wait_for_keypress;
docker rm nostalgic_morse

echo -n "# sudo docker stop nostalgic_morse"
wait_for_keypress;
docker stop nostalgic_morse

echo -n "# sudo docker rm nostalgic_morse"
wait_for_keypress;
docker rm nostalgic_morse

# https://docs.docker.com/userguide/dockerimages/
echo -----------------------------------------------------------------
echo -n "# https://docs.docker.com/userguide/dockerimages/"
wait_for_keypress;

# Listing images on the host
echo --------------------------------01: Listing images on the host---------------------------------
echo -n '# sudo docker images'
wait_for_keypress;
docker images

# Getting a new image
echo --------------------------------02: Getting a new image---------------------------------
echo -n '# sudo docker pull centos'
wait_for_keypress;
docker pull centos

echo '# sudo docker run -t -i centos /bin/bash'
echo -n "# type exit when you are done looking around"
wait_for_keypress;
if [[ $INTERACTIVE == '1' ]];
then
    docker run -t -i centos /bin/bash
fi

# Finding images
echo --------------------------------03: Finding images---------------------------------
echo -n '# sudo docker search sinatra'
wait_for_keypress;
docker search sinatra

# Pulling our image
echo --------------------------------04: Pulling our image---------------------------------
echo -n '# sudo docker pull training/sinatra'
wait_for_keypress;
docker pull training/sinatra

echo '# sudo docker run -t -i training/sinatra /bin/bash'
echo -n "# type exit when you are done looking around"
wait_for_keypress;
if [[ $INTERACTIVE == '1' ]];
then
    docker run -t -i training/sinatra /bin/bash
fi

# Creating our own images
echo --------------------------------05: Creating our own images---------------------------------
echo '# sudo docker run -t -i training/sinatra /bin/bash'
echo "# type 'gem install json' inside your container"
echo -n "# type exit when you are done"
wait_for_keypress;
if [[ $INTERACTIVE == '1' ]];
then
    docker run -t -i training/sinatra /bin/bash
else
    docker run training/sinatra gem install json
fi

CONTAINER_ID=$(docker ps -l -q)

echo -n "# sudo docker commit -m 'Added json gem' -a \"$DOCKER_AUTHOR\" $CONTAINER_ID $OUR_USER/sinatra:v1"
wait_for_keypress;
docker commit -m "Added json gem" -a "$DOCKER_AUTHOR" $CONTAINER_ID $OUR_USER/sinatra:v1

echo -n '# sudo docker images'
wait_for_keypress;
docker images

echo -n "# sudo docker run -t -i $OUR_USER/sinatra:v1 /bin/bash"
wait_for_keypress;
if [[ $INTERACTIVE == '1' ]];
then
    docker run -t -i $OUR_USER/sinatra:v1 /bin/bash
fi

# Building an image from a Dockerfile
echo --------------------------------06: Building an image from a Dockerfile---------------------------------
echo -n "mkdir sinatra"
wait_for_keypress;
mkdir sinatra
echo -n "cd sinatra"
wait_for_keypress;
cd sinatra
echo -n "touch Dockerfile"
wait_for_keypress;
touch Dockerfile

if [[ $INTERACTIVE == '1' ]];
then
    $EDITOR Dockerfile
else
    echo "# This is a comment
FROM ubuntu:14.04
MAINTAINER $DOCKER_AUTHOR <$DOCKER_EMAIL>
RUN apt-get update && apt-get install -y ruby ruby-dev
RUN gem install sinatra
" >> Dockerfile
fi

echo -n "cat Dockerfile"
wait_for_keypress;
cat Dockerfile

echo -n "# sudo docker build -t $OUR_USER/sinatra:v2 ."
wait_for_keypress;
docker build -t $OUR_USER/sinatra:v2 .

# Setting tags on an image
# Image Digests
# Push an image to Docker Hub
# Remove an image from the host

# https://docs.docker.com/userguide/dockerlinks/
# https://docs.docker.com/userguide/dockervolumes/