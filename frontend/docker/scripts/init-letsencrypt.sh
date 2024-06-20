#!/bin/bash

set -e

echo "ABRINDO TEMPORARIAMENTE O NGINX..."
nginx &

# Esperar alguns segundos para o Nginx iniciar
sleep 5

echo "PARANDO TEMPORARIAMENTE O NGINX..."
nginx -s stop

echo "RODANDO CERTBOT..."
# Gerar os certificados SSL usando Certbot standalone
certbot certonly --standalone --non-interactive --agree-tos -m felipijohnny@outlook.com -d denuncia.amalfis.com.br || {
  echo "Certbot failed"
  cat /var/log/letsencrypt/letsencrypt.log
  exit 1
}

# Verificar se os certificados foram gerados
if [ -f /etc/letsencrypt/live/denuncia.amalfis.com.br/fullchain.pem ]; then
    echo "CERTIFICADOS GERADOS COM SUCESSO."
else
    echo "FALHA AO GERAR CERTIFICADOS."
    cat /var/log/letsencrypt/letsencrypt.log
    exit 1
fi

echo "ATUALIZANDO ARQUIVO DE CONFIGURAÇÃO DO NGINX COM O SSL..."
# Copiar a configuração do Nginx para usar SSL
cp /etc/nginx/conf.d/denuncia.amalfis.com.br.ssl.conf /etc/nginx/conf.d/denuncia.amalfis.com.br.conf

echo "REINICIANDO NGINX..."
# Reiniciar o Nginx em modo daemon off com a nova configuração
nginx -s stop
nginx -g "daemon off;"
