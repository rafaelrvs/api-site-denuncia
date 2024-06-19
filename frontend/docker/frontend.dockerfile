FROM node:latest

WORKDIR /app

COPY . /app

WORKDIR /app/frontend

RUN npm install

RUN npm run build


