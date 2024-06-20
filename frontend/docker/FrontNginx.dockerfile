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

# Instalar Certbot e cron com os repositórios adicionais
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    echo "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y certbot python-certbot-nginx cron

# Copiar a configuração personalizada do Nginx sem SSL
COPY ./frontend/docker/config/denuncia.amalfis.com.br.conf /etc/nginx/conf.d/denuncia.amalfis.com.br.conf

# Copiar a configuração personalizada do Nginx com SSL
COPY ./frontend/docker/config/denuncia.amalfis.com.br.ssl.conf /etc/nginx/conf.d/denuncia.amalfis.com.br.ssl.conf

# Copiar o script de inicialização
COPY ./frontend/docker/scripts/init-letsencrypt.sh /init-letsencrypt.sh
RUN chmod +x /init-letsencrypt.sh

# Copiar o arquivo de cron job
COPY ./frontend/docker/scripts/crontab /etc/cron.d/certbot-renew

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
