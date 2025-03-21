FROM debian:bullseye

ARG DOMAIN_NAME
ENV DOMAIN_NAME=${DOMAIN_NAME}

RUN apt-get update && apt-get install -y\
    nginx \
    openssl \
    gettext-base

RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=DE/ST=BW/O=42HN/CN=${DOMAIN_NAME}"

COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf
COPY ./tools/start_nginx.sh /start_nginx.sh
RUN chmod +x /start_nginx.sh

EXPOSE 443

ENTRYPOINT ["/start_nginx.sh"]
