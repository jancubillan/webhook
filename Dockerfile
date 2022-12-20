FROM rockylinux:9

ENV SERIAL=268

RUN yum clean all && \
    yum makecache && \
    yum update -y && \
    yum install -y wget tar && \
    wget -O /tmp/webhook-linux-amd64.tar.gz https://github.com/adnanh/webhook/releases/download/2.8.0/webhook-linux-amd64.tar.gz && \
    cd /tmp && \
    tar xvf /tmp/webhook-linux-amd64.tar.gz && \
    cp webhook-linux-amd64/webhook /usr/local/bin/ && \
    rm -rf webhook-linux-amd64 webhook-linux-amd64.tar.gz && \
    chmod +x /usr/local/bin/webhook

WORKDIR /config

EXPOSE 9000

ENTRYPOINT ["webhook"]

CMD ["-verbose", "-hotreload", "-hooks=hooks.json"]
