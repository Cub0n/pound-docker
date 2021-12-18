# pound-docker
Project for Building a Pound Docker Container

## Forewords
No, I have no Docker Hub account and I will not provide any Docker image.

## What is Pound
Pound is a small reverse proxy.
* https://www.apsis.ch/pound.html
* https://en.wikipedia.org/wiki/Pound_%28networking%29

Building it up with alpine has an image under 10MB (on Arm)

## Configuration
Pound can listen on many TCP ports which can be redirected to backend containers/services.
More can be found at:
* https://help.ubuntu.com/community/Pound
* https://manpages.ubuntu.com/manpages/latest/en/man8/pound.8.html
* https://www.cyberciti.biz/faq/linux-http-https-reverse-proxy-load-balancer/

## Build
Change to directory where the Dockerfile is located and execute: _docker build -t pound:latest_.
You can choose the tag (-t) on your own. The builded image is automatically added to your local docker image repository.

## Run
docker run -d -p 80:80 -p 443:443 -p 4443:4443 \
        --restart=unless-stopped \
        --name pound \
        -v /path/to/pound.cfg:/etc/pound.cfg \
        -v /path/to/pound.pem:/etc/pound/pound.pem \
        --network dedicated-network \
        pound:latest

## Security
Please secure your docker container everytime!
Run it as dockerless container, keep your images actual, reduce complexity.

## Some pitfalls
* Pound has to be configured *not* in Daemon mode (see pound.cfg DAEMON 0). If it is configured as a deamon the docker container will start, pound is started and then (because it is a background process) docker receives an exit 0, which means the application is down and Docker stops the container. The process has to be a foreground process!
* Pound can be configured to use a Web Certificate to communicate with HTTPs to the outside world and internally without encryption.
The certificate has to be in PEM format and has to included the certificate itself (e.g. domain.crt) and the key file (e.g. domain.key). Concatenate both with _cat domain.crt domain.key > domain.pem_ in linux shell (see also the manpage, section Cert). The final PEM file should have the name of your domain, e.g. _domain.example.org_ then name it as _domain.example.org.pem_.
* Using docker's own DNS resolver, pound has to be in it's own network (not the default _bridge_ network) with other services (see https://docs.docker.com/engine/reference/commandline/network_create/)
* Check the Path to the pound files and the mapping inside _pound.cfg_
