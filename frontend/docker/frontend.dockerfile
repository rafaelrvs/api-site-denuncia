# Etapa 1: Construção do frontend
FROM node:latest AS build-stage

WORKDIR /app

COPY . /app

WORKDIR /app/frontend

RUN npm install
RUN npm run build
