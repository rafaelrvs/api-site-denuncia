FROM node:latest AS build-stage

WORKDIR /app

COPY . /app

WORKDIR /app/backend

RUN npm install

RUN npm install pm2 -g

EXPOSE 3000

# Configura o PM2 para utilizar o arquivo .env
CMD ["pm2-runtime", "server.js"]
