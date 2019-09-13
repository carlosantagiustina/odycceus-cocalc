# Docker container: odycceus cocalc

This is a modified verison of the cocalc container built by C. Santagiustina for the Odycceus Summer School.

To build the more recent developer version of the container in your machine (only linux) install Docker and run on your terminal these commands:

```
sudo  docker build --force-rm  https://github.com/carlosantagiustina/odycceus-cocalc.git -t   carlosantagiustina/odycceus-cocalc:dev
```

Alternatively, to download the (latest stable) developer version of the container from [dockerhub](https://hub.docker.com/r/carlosantagiustina/odycceus-cocalc), run on your terminal these commands:
```
docker pull carlosantagiustina/odycceus-cocalc:dev
```

To run the container (only linux):
```
sudo docker run --name=odycceus-cocalc --restart always -d -v [PATH TO THE FOLDER WHERE THE COCALC PROJECTS AND SESSIONS WIL BE SAVED LOCALLY]:/projects -p 443:443  carlosantagiustina/odycceus-cocalc:dev
```

To run the container (other OS):
```
docker volume create cocalc-volume
docker run --name=odycceus-cocalc --restart always -d -v cocalc-volume:/projects -p 443:443  carlosantagiustina/odycceus-cocalc:dev
```
