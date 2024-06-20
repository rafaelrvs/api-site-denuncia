#!/bin/bash

# Renovar certificados a cada 12 horas
while true; do
    certbot renew
    chmod 644 /etc/letsencrypt/live/denuncia.amalfis.com.br/fullchain.pem
    chmod 600 /etc/letsencrypt/live/denuncia.amalfis.com.br/privkey.pem
    nginx -s reload
    sleep 12h
done
