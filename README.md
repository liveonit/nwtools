[![CI workflow](https://img.shields.io/github/workflow/status/ibarretorey/nwtools/ci?label=ci&logo=github&style=flat-square)](https://github.com/ibarretorey/nwtools/actions)

# nwtools

This is a multitool for container/network testing and troubleshooting. It was originally built with Fedora, but is now based on Alpine Linux. The container image contains lots of tools, as well as nginx web server, which listens on port 80 and 443 by default. The web server helps to run this container-image in a straight-forward way, so you can simply `exec` into the container and use various tools.

## Tools included

* apk package manager
* Nginx Web Server (port 80, port 443) - customisable ports!
* wget, curl, iperf3
* dig, nslookup
* ip, ifconfig, mii-tool, route
* ping, nmap, arp, arping
* awk, sed, grep, cut, diff, wc, find, vi editor
* netstat, ss
* gzip, cpio
* tcpdump
* telnet client, ssh client, ftp client, rsync, tshark
* traceroute, tracepath, mtr
* netcat (nc), socat
* ApacheBench (ab)
* mysql client
* postgresql client
* jq
* git
* ansible
* ansible-tower-cli
* awscli
* boto
* boto3
* cloud-nuke
* dops

**Note:** The SSL certificates are generated for 'localhost', are self signed, and placed in `/certs/` directory. During your testing, ignore the certificate warning/error. While using curl, you can use `-k` to ignore SSL certificate warnings/errors.

## Configurable HTTP and HTTPS ports

There are times when one may want to join this (multitool) container to another container's IP namespace for troubleshooting. This is true for both Docker and Kubernetes platforms. During that time if the container in question is a web server (nginx), then nwtools cannot join it in the same IP namespace on Docker, and similarly it cannot join the same pod on Kubernetes. This is because nwtools also runs a web server on port 80 (and 443), and this results in port conflict on the same IP address. To help in this sort of troubleshooting, there are two envronment variables **HTTP_PORT** and **HTTPS_PORT** , which you can use to provide the values of your choice instead of 80 and 443. When the container starts, it uses the values provided by you/user to listen for incoming connections. Below is an example:

```bash
docker run -e HTTP_PORT=1180 -e HTTPS_PORT=1443 -p 1180:1180 -p 1443:1443 -d local/nwtools
```  

If these environment variables are absent/not provided, the container will listen on normal/default ports 80 and 443.

## Usage examples

### Docker

```bash
docker run --rm -it ibarretorey/nwtools /bin/bash
```

### Docker-compose

```bash
docker run --name multitool-net  -d ibarretorey/nwtools
kubectl exec -it multitool-net  bash # to connect with container
```

### K8s

```bash
kubectl run multitool --image=ibarretorey/nwtools --replicas=1
docker exec -it multitool-net bash # to connect with container
```

## Build and Push (to dockerhub) instructions

```bash
docker build -t local/nwtools .
docker tag local/nwtools ibarretorey/nwtools
docker login
docker push ibarretorey/nwtools
```

## Pull (from dockerhub)

```bash
docker pull ibarretorey/nwtools
```
