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

# Criar diretórios e definir permissões corretas
RUN mkdir -p /etc/letsencrypt/live/denuncia.amalfis.com.br && \
    chmod 755 /etc /etc/letsencrypt /etc/letsencrypt/live /etc/letsencrypt/live/denuncia.amalfis.com.br

# Expor as portas
EXPOSE 80 443

# Comando para iniciar o Nginx e o script de renovação de certificados
CMD ["sh", "-c", "/usr/local/bin/renew_certificates.sh & nginx -g 'daemon off;'"]
