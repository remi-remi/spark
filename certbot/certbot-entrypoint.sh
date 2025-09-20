#!/bin/sh

CERT_PATH="/etc/letsencrypt/live/${DOMAIN}/fullchain.pem"

echo " Certbot-entrypoint.sh

                                 #
                                 ##
                                 # #
                                 #  #
                                 #   #
                            V    # ##
                                 ##
                                ##
                              ## #   3
                             #   #
                              #  #
                               # #
                                ##
                                 #
"

echo "	------------------------------------------------
	certbot entrypoint context : 
	DOMAIN: ${DOMAIN}
	MAINTAINER_MAIL: ${MAINTAINER_MAIL}
	you can change this parameter on .env.PROXY-
   	fullchain path: ${CERT_PATH}
	------------------------------------------------
"

pwd

if [ -f "$CERT_PATH" ]; then
  echo " > Certificate exists at $CERT_PATH"
  echo " > Trying to renew existing certificate..."
  certbot renew || {
    echo " # Certificate renewal failed"
    exit 1
  }
else
  echo " > No certificate found. Issuing a new certificate..."
  certbot certonly -v \
    --webroot -w /var/www/certbot \
    --email "${MAINTAINER_MAIL}" \
    --agree-tos --no-eff-email \
    -d "${DOMAIN}" || {
      echo " # Certificate generation failed"
      exit 1
    }
fi

echo "------------------------------------------------------------------------------------"
crond -f -l 0
