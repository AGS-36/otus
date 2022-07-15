FROM alpine:latest
RUN apk --update --no-cache add\
    openrc\
    nginx\
    curl
RUN adduser -D -g 'www' www
RUN mkdir /www; chown -R www:www /var/lib/nginx; chown -R www:www /www
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /www/index.html
RUN rc-update add nginx default
RUN nginx -t; nginx
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
