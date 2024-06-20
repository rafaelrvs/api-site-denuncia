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

# Instalar Certbot e cron
RUN apt-get update && apt-get install -y certbot python3-certbot-nginx cron

# Copiar a configuração personalizada do Nginx
COPY /docker/config/denuncia.amalfis.com.br.conf /etc/nginx/conf.d/denuncia.amalfis.com.br.conf

# Copiar o script de inicialização
COPY /docker/scripts/init-letsencrypt.sh /init-letsencrypt.sh
RUN chmod +x /init-letsencrypt.sh

# Copiar o arquivo de cron job
COPY /docker/scripts/crontab /etc/cron.d/certbot-renew

# Dar permissão correta ao arquivo de cron job
RUN chmod 0644 /etc/cron.d/certbot-renew

# Aplicar os cron jobs
RUN crontab /etc/cron.d/certbot-renew

# Criar o diretório para o cron
RUN touch /var/log/cron.log

# Expor as portas
EXPOSE 80 443

# Comando para iniciar o script de inicialização e cron
CMD ["/bin/bash", "-c", "/init-letsencrypt.sh && cron && tail -f /var/log/cron.log"]
