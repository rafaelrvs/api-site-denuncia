# Etapa 1: Construção do frontend
FROM node:latest AS build-stage

WORKDIR /app

COPY . /app

WORKDIR /app/frontend

RUN npm install
RUN npm run build

# Etapa 2: Configuração do Nginx
FROM nginx:latest

# Copiar os arquivos construídos do estágio anterior
COPY --from=build-stage /app/frontend/dist /usr/share/nginx/html

# Copiar a configuração personalizada do Nginx
COPY ./frontend/docker/config/nginx.conf /etc/nginx/nginx.conf

# Expor as portas
EXPOSE 80 443

# Comando para iniciar o Nginx
CMD ["nginx", "-g", "daemon off;"]
