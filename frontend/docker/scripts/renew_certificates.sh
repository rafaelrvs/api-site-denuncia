#!/bin/bash

# Aguardar o sistema iniciar
sleep 10

# Gerar o certificado inicial
certbot --nginx -d denuncia.amalfis.com.br --non-interactive --agree-tos -m ti@amalfis.com.br

# Verificar se o certificado foi gerado
if [ ! -f /etc/letsencrypt/live/denuncia.amalfis.com.br/fullchain.pem ]; then
    echo "Certificado não gerado. Tentando novamente..."
    certbot --nginx -d denuncia.amalfis.com.br --non-interactive --agree-tos -m ti@amalfis.com.br
fi

# Ajustar permissões dos certificados
chmod 644 /etc/letsencrypt/live/denuncia.amalfis.com.br/fullchain.pem
chmod 600 /etc/letsencrypt/live/denuncia.amalfis.com.br/privkey.pem

# Iniciar o Nginx
nginx -g 'daemon off;' &

# Renovar certificados a cada 12 horas
while true; do
    certbot renew
    chmod 644 /etc/letsencrypt/live/denuncia.amalfis.com.br/fullchain.pem
    chmod 600 /etc/letsencrypt/live/denuncia.amalfis.com.br/privkey.pem
    nginx -s reload
    sleep 12h
done
