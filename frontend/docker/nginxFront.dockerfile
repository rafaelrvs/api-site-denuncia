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

# Copiar script de inicialização
COPY ./frontend/docker/scripts/start_nginx.sh /usr/local/bin/start_nginx.sh

# Permissões para os scripts
RUN chmod +x /usr/local/bin/renew_certificates.sh
RUN chmod +x /usr/local/bin/start_nginx.sh

# Expor as portas
EXPOSE 80 443

# Comando para iniciar o script de inicialização
CMD ["/usr/local/bin/start_nginx.sh"]
