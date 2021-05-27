FROM alpine:3.13

RUN apk update \
 && apk upgrade \
 && apk add --no-cache \
    rsync openssh-client ca-certificates \
 && update-ca-certificates \
 && rm -rf /var/cache/apk/*

#  COPY rsync/entrypoint.sh /entrypoint.sh
 COPY entrypoint.sh /entrypoint.sh

WORKDIR /mnt/dst/


