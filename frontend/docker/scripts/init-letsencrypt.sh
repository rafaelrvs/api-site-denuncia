#!/bin/bash

# Função para solicitar o certificado Let's Encrypt
request_cert() {
    certbot certonly --standalone --non-interactive --agree-tos -m "$CERTBOT_EMAIL" -d "$DOMAIN_NAME" || return 1
    return 0
}

# Função para renovar o certificado Let's Encrypt
renew_cert() {
    certbot renew --non-interactive || return 1
    return 0
}

# Verifica se as variáveis de ambiente DOMAIN_NAME e CERTBOT_EMAIL estão definidas
if [ -z "$DOMAIN_NAME" ]; then
    echo "A variável de ambiente DOMAIN_NAME não está definida."
    exit 1
fi

if [ -z "$CERTBOT_EMAIL" ]; then
    echo "A variável de ambiente CERTBOT_EMAIL não está definida."
    exit 1
fi

# Verifica se o certificado já existe
if [ -d "/etc/letsencrypt/live/$DOMAIN_NAME" ]; then
    echo "Certificado já existe, tentando renovar..."
    if ! renew_cert; then
        echo "Renovação do Certificado falhou, tentando solicitar um novo..."
        if ! request_cert; then
            echo "Certbot falhou, gerando certificado autoassinado"
            mkdir -p /etc/letsencrypt/live/${DOMAIN_NAME}
            openssl req -x509 -nodes -days 30 -newkey rsa:2048 -keyout /etc/letsencrypt/live/${DOMAIN_NAME}/privkey.pem -out /etc/letsencrypt/live/${DOMAIN_NAME}/fullchain.pem -subj "/CN=${DOMAIN_NAME}"
        else
            echo "Certbot obteve um certificado com sucesso"
        fi
    else
        echo "Certificado renovado com sucesso"
    fi
else
    echo "Certificado não existe, solicitando um novo..."
    if ! request_cert; then
        echo "Certbot falhou, gerando certificado autoassinado"
        mkdir -p /etc/letsencrypt/live/${DOMAIN_NAME}
        openssl req -x509 -nodes -days 30 -newkey rsa:2048 -keyout /etc/letsencrypt/live/${DOMAIN_NAME}/privkey.pem -out /etc/letsencrypt/live/${DOMAIN_NAME}/fullchain.pem -subj "/CN=${DOMAIN_NAME}"
    else
        echo "Certbot obteve um certificado com sucesso"
    fi
fi

# Reinicia o Nginx para aplicar as novas configurações com SSL
nginx -g 'daemon off;' &

# Loop para verificar e tentar renovar o certificado Let's Encrypt a cada 24 horas
while true; do
  sleep 24h
  if renew_cert; then
    echo "Certificado renovado com sucesso, reiniciando Nginx"
    nginx -s reload
  else
    echo "Renovação do Certificado falhou, tentando novamente em 24 horas"
  fi
done
