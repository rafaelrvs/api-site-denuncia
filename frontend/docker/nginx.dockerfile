FROM  nginx:latest

WORKDIR /app

EXPOSE 80 443

ENTRYPOINT [ "nginx" ]

CMD ["-g", "daemon off;"]