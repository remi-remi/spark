#!/bin/sh

# Check if SSL certificates are present, else serve only the ACME challenge
if [ ! -f "$SSL_CERT_PATH" ] || [ ! -f "$SSL_KEY_PATH" ]; then
    echo "Certificats SSL manquants, utilisation d'une configuration minimale pour Certbot..."
    
    # Serve only the ACME challenge for Certbot if SSL is not ready
    cat <<EOF > /etc/nginx/nginx.conf
events {
    worker_connections 1024;
}

http {
    server {
        listen 80;
        server_name ${DOMAIN};

        # Gestion des requêtes Let's Encrypt
        location /.well-known/acme-challenge/ {
            root /var/www/certbot;
            try_files \$uri =404;
        }

        # Si un utilisateur essaie d'accéder à autre chose, retour 503
        location / {
            return 503 "Waiting for SSL certificates...";
        }
    }
}
EOF

    nginx -g 'daemon off;' &
    NGINX_PID=$!

    # Wait for Certbot to generate valid certificates
		printf "Waiting for SSL certificates from Certbot"
		while [ ! -f "/etc/nginx/ssl/live/${DOMAIN}/fullchain.pem" ] || [ ! -f "/etc/nginx/ssl/live/${DOMAIN}/privkey.pem" ]; do
		    printf "."
		    sleep 1
		done
		echo " done."


    # Reload Nginx with SSL-enabled configuration after Certbot gets certificates
    echo "Certificats SSL valides trouvés, redémarrage de Nginx avec la configuration complète..."
    nginx -s stop || true
    kill -HUP "$NGINX_PID"
else
    echo "SSL CERT PRESENT ON : '$SSL_CERT_PATH'"
    echo "SSL KEY  PRESENT ON : '$SSL_KEY_PATH'"
    echo "no need to use the hackme configuration"
fi

echo 'change nginx configuration'
# Full Nginx configuration with SSL
envsubst '\$DOMAIN \$SSL_CERT_PATH \$SSL_KEY_PATH' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
envsubst '\$DOMAIN' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf

installAndConfigureCron() {
	apt-get update > /dev/null;
	apt-get install cron -y > /dev/null;

	if [ -n "$TZ" ]; then
	  echo "Setting timezone to $TZ"
	  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime
	  echo $TZ > /etc/timezone
	  dpkg-reconfigure -f noninteractive tzdata
	else
	  echo "No TZ environment variable provided, using default timezone"
	fi

	# TEST each 3 minutes
	#echo "*/3 * * * * /usr/sbin/nginx -s reload >> /var/log/cron.log 2>&1" >> /var/spool/cron/crontabs/root	
	#echo "* * * * * echo 'TESTCRON proxy' >> /tmp/testCron.log 2>&1" >> /var/spool/cron/crontabs/root
	# PROD once per week, 00:05 right after certbot restart
   echo "5 0 * * 6 /usr/sbin/nginx -s reload >> /var/log/cron.log 2>&1" >> /var/spool/cron/crontabs/root

	cron;
	
	sleep 10
	# force cron to refresh his conf
	crontab -l | crontab - ; 
}

(installAndConfigureCron) &

echo "STOP NGINX-------------"
nginx -s stop || true

echo "wait 15 segonds"
sleep 15

echo "RESTART NGINX------------"
nginx -g 'daemon off;'


