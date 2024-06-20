#!/bin/bash

echo "Starting temporary Nginx server..."
nginx &

# Esperar alguns segundos para o Nginx iniciar
sleep 5

echo "Stopping temporary Nginx server..."
nginx -s stop

echo "Running Certbot..."
# Gerar os certificados SSL usando Certbot
certbot --nginx -d denuncia.amalfis.com.br -m ti@amalfis.com.br --agree-tos --no-eff-email --non-interactive --redirect

# Verificar se os certificados foram gerados
if [ -f /etc/letsencrypt/live/denuncia.amalfis.com.br/fullchain.pem ]; then
    echo "Certificates generated successfully."
else
    echo "Failed to generate certificates."
    exit 1
fi

echo "Starting Nginx with SSL..."
# Iniciar o Nginx em modo daemon off
nginx -g "daemon off;"
