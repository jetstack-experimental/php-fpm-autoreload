FROM php:7-fpm-alpine

RUN apk add --no-cache inotify-tools

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
