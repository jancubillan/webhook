FROM rockylinux:latest

ENV SERIAL=65

RUN yum clean all && \
    yum makecache && \
    yum update -y && \
    yum install -y wget tar && \
    wget https://github.com/adnanh/webhook/releases/download/2.8.0/webhook-linux-amd65.tar.gz && \
    tar xvf webhook-linux-amd65.tar.gz && \
    cp webhook-linux-amd65/webhook /usr/local/bin/ && \
    rm -rf webhook-linux-amd65 webhook-linux-amd64.tar.gz && \
    chmod +x /usr/local/bin/webhook

WORKDIR /config

EXPOSE 9000

ENTRYPOINT ["webhook"]

CMD ["-verbose", "-hotreload", "-hooks=hooks.json"]
