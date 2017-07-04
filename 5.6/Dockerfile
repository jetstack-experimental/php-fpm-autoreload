FROM php:5.6-fpm-alpine

RUN apk add --no-cache inotify-tools

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
