# base image
FROM alpine:latest

# maintainer
MAINTAINER Karel Fiala <fiala.karel@gmail.com>

# install
RUN apk --no-cache add nginx openssl curl \
    && mkdir /etc/nginx/certs \
    && mkdir /etc/nginx/sites \
    && wget -O - https://get.acme.sh | sh

# copy prepared nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# set startup command
ENTRYPOINT nginx
