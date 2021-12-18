FROM alpine:latest

RUN apk upgrade && apk add --no-cache pound

COPY pound.cfg /etc/pound.cfg

EXPOSE 80 443

ENTRYPOINT ["/usr/sbin/pound", "-f", "/etc/pound.cfg"]
