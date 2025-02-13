FROM rockylinux:9 AS build

ENV SERIAL=1063

RUN yum clean all && \
    yum makecache && \
    yum install -y wget tar gzip && \
    wget https://github.com/adnanh/webhook/releases/download/2.8.0/webhook-linux-amd64.tar.gz && \
    tar xvf webhook-linux-amd64.tar.gz && \
    cp webhook-linux-amd64/webhook /usr/local/bin/ && \
    rm -rf webhook-linux-amd64 webhook-linux-amd64.tar.gz && \
    chmod +x /usr/local/bin/webhook

FROM rockylinux:9-minimal

RUN microdnf clean all && \
    microdnf makecache && \
    microdnf update -y

COPY --from=build /usr/local/bin/webhook /usr/local/bin/webhook

WORKDIR /config

EXPOSE 10630

ENTRYPOINT ["webhook"]

CMD ["-verbose", "-hotreload", "-hooks=hooks.json"]
