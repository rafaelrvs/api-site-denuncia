#!/bin/bash

# Aguardar o Nginx iniciar
sleep 10

# Gerar o certificado inicial
certbot --nginx -d denuncia.amalfis.com.br --non-interactive --agree-tos -m ti@amalfis.com.br

# Verificar se o certificado foi gerado
if [ ! -f /etc/letsencrypt/live/denuncia.amalfis.com.br/fullchain.pem ]; then
    echo "Certificado não gerado. Tentando novamente..."
    certbot --nginx -d denuncia.amalfis.com.br --non-interactive --agree-tos -m ti@amalfis.com.br
fi

# Renovar certificados a cada 12 horas
while true; do
    certbot renew
    sleep 12h
done
