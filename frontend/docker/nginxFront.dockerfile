# Etapa 1: Construção do frontend
FROM node:latest AS build-stage

WORKDIR /app

COPY . /app

WORKDIR /app/frontend

RUN npm install
RUN npm run build

# Etapa 2: Configuração do Nginx e Certbot
FROM nginx:latest

# Copiar os arquivos construídos do estágio anterior
COPY --from=build-stage /app/frontend/dist /usr/share/nginx/html

# Instalar Certbot
RUN apt-get update && apt-get install -y certbot python3-certbot-nginx

# Copiar a configuração personalizada do Nginx
COPY ./frontend/docker/config/denuncia.amalfis.com.br.conf /etc/nginx/conf.d/denuncia.amalfis.com.br.conf

# Copiar o script de inicialização
COPY ./frontend/docker/init-letsencrypt.sh /init-letsencrypt.sh
RUN chmod +x /init-letsencrypt.sh

# Expor as portas
EXPOSE 80 443

# Comando para iniciar o script de inicialização
CMD ["/init-letsencrypt.sh"]
