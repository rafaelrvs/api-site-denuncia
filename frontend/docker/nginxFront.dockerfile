# Etapa 1: Construção do frontend
FROM node:latest AS build-stage

WORKDIR /app

COPY . /app

WORKDIR /app/frontend

RUN npm install
RUN npm run build

# Etapa 2: Configuração do Nginx com Certbot
FROM nginx:latest

# Instalar Certbot
RUN apt-get update && apt-get install -y certbot python3-certbot-nginx

# Copiar os arquivos construídos do estágio anterior
COPY --from=build-stage /app/frontend/dist /usr/share/nginx/html

# Copiar a configuração personalizada do Nginx
COPY ./frontend/docker/config/denuncia.amalfis.com.br.conf /etc/nginx/conf.d/denuncia.amalfis.com.br.conf

# Copiar script para renovar certificados
COPY ./frontend/docker/scripts/renew_certificates.sh /usr/local/bin/renew_certificates.sh

# Permissões para o script
RUN chmod +x /usr/local/bin/renew_certificates.sh

# Adicionando comandos para ajustar permissões
RUN mkdir -p /etc/letsencrypt/live/denuncia.amalfis.com.br && \
    chmod 644 /etc/letsencrypt/live/denuncia.amalfis.com.br/fullchain.pem && \
    chmod 600 /etc/letsencrypt/live/denuncia.amalfis.com.br/privkey.pem

# Expor as portas
EXPOSE 80 443

# Comando para iniciar o Nginx e o script de renovação de certificados
CMD ["sh", "-c", "/usr/local/bin/renew_certificates.sh & nginx -g 'daemon off;'"]
