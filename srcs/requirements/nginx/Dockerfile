FROM debian:bullseye

RUN apt-get update && apt-get install -y\
	nginx \
	openssl

RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=DE/ST=BW/O=42HN/CN=$DOMAIN_NAME" 

COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 443

#ENTRYPOINT

CMD ["nginx", "-g", "daemon off;"]
