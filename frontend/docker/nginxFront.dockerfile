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
COPY ./frontend/docker/config/denuncia.amalfis.com.br.conf /etc/nginx/conf.d/denuncia.amalfis.com.br.conf

# Criar diretórios e definir permissões corretas
RUN mkdir -p /etc/letsencrypt/live/denuncia.amalfis.com.br && \
    chmod -R 777 /etc /etc/letsencrypt /etc/letsencrypt/live /etc/letsencrypt/live/denuncia.amalfis.com.br

# Expor as portas
EXPOSE 80 443

# Comando para iniciar o Nginx
CMD ["nginx", "-g", "daemon off;"]
