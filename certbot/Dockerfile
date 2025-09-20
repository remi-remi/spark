FROM certbot/certbot

# Installe envsubst pour la substitution de variables d'environnement
ENV TZ=Europe/Paris
RUN apk add --no-cache gettext dcron tzdata\
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone

# TEST, each 2 minute

#RUN echo "*/2 * * * * certbot renew --force-renewal >> /var/log/certbot.log 2>&1" >> /etc/crontabs/root
#RUN echo "* * * * * echo 'TESTCRON certbot' >> /tmp/testCron.log" >> /etc/crontabs/root

# PROD once per week 00:00
RUN echo "0 0 * * 6 certbot renew --quiet >> /var/log/certbot.log 2>&1" >> /etc/crontabs/root

# TEST, each 1 hour :
#RUN echo "0 */1 * * * certbot renew --quiet --force-renewal >> /var/log/certbot.log 2>&1" >> /etc/crontabs/root

RUN crond restart

# Copie un script shell dans le conteneur
COPY certbot-entrypoint.sh /usr/local/bin/certbot-entrypoint.sh

# Rendre le script exécutable
RUN chmod +x /usr/local/bin/certbot-entrypoint.sh

