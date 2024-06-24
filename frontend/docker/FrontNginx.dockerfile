# Etapa 1: Construção do frontend
FROM node:latest AS build-stage

WORKDIR /app

COPY . /app

WORKDIR /app/frontend

RUN npm install
RUN npm run build

# Etapa 2: Configuração do Nginx e Certbot
FROM feljohnny/nginx-certbot:0.4

# Copiar os arquivos construídos do estágio anterior
COPY --from=build-stage /app/frontend/dist /usr/share/nginx/html

# Copiar a configuração principal do Nginx
COPY ./frontend/docker/config/nginx.conf /etc/nginx/nginx.conf

# Copiar a configuração personalizada do Nginx
COPY ./frontend/docker/config/denuncia.amalfis.com.br.conf /etc/nginx/conf.d/denuncia.amalfis.com.br.conf

# Copiar o script de inicialização
COPY ./frontend/docker/scripts/init-letsencrypt.sh /init-letsencrypt.sh

RUN chmod +x /init-letsencrypt.sh

# Expor as portas
EXPOSE 80 443

# Comando para iniciar o script de inicialização
ENTRYPOINT ["/init-letsencrypt.sh"]
