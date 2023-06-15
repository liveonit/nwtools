FROM alpine:3.13.3

RUN apk update \
    &&  apk add apache2-utils bash bind-tools busybox-extras curl ethtool git \
        iperf3 iproute2 iputils jq lftp mtr mysql-client \
        netcat-openbsd net-tools nginx nmap openssh-client openssl \
	      perl-net-telnet postgresql-client procps rsync socat tcpdump tshark wget \
    &&  mkdir /certs \
    &&  chmod 700 /certs

RUN openssl req \
    -x509 -newkey rsa:2048 -nodes -days 3650 \
    -keyout /certs/server.key -out /certs/server.crt -subj '/CN=localhost'

COPY index.html /usr/share/nginx/html/

COPY nginx.conf /etc/nginx/nginx.conf
COPY nginx-connectors.conf /etc/nginx/conf.d/default.conf

ENV ANSIBLE_VERSION=2.13


RUN set -xe \
    && echo "****** Install system dependencies ******" \
    && apk add --no-cache --progress python3 openssl \
		ca-certificates git openssh sshpass \
	&& apk --update add \
		python3-dev py3-pip libffi-dev openssl-dev build-base gcc musl-dev cargo

RUN echo "****** Install ansible and python dependencies ******" \
    && pip3 install --upgrade pip

RUN pip3 install ansible==${ANSIBLE_VERSION} boto3 crypto \
    && echo "****** Remove unused system librabies ******" \
	&& rm -rf /var/cache/apk/*

RUN pip install ansible-tower-cli

RUN pip3 install pyOpenSSL awscli boto

RUN set -xe \
    && mkdir -p /etc/ansible \
    && echo -e "[local]\nlocalhost ansible_connection=local" > \
        /etc/ansible/hosts

RUN curl -L https://github.com/gruntwork-io/cloud-nuke/releases/download/v0.1.25/cloud-nuke_linux_amd64 --output cloud-nuke\
    && mv cloud-nuke /usr/local/bin/cloud-nuke && chmod a+x /usr/local/bin/cloud-nuke

EXPOSE 80 443

COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
