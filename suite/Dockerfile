ARG BACK_END
FROM ghcr.io/deck-app/${BACK_END}:v7.4
LABEL maintainer Naba Das <hello@get-deck.com>

RUN mkdir -p /app
RUN mkdir -p /var/preview
COPY default.conf /app/default.conf
COPY httpd.conf /app/httpd.conf
RUN wget -O /var/preview/index.html https://raw.githubusercontent.com/deck-app/stack-preview-screen/main/install/index.html

ARG SERVER_ROOT
ARG BACK_END
RUN if [ ${BACK_END} = nginx ]; then \
    cp /app/default.conf /etc/nginx/conf.d/default.conf && \
    sed -i "s#{SERVER_ROOT}#/var/preview#g" /etc/nginx/conf.d/default.conf && \
    sed -i "s#{SERVER_ROOT}#/var/www/public/#g" /app/default.conf \
;else \
    cp /app/httpd.conf /etc/apache2/httpd.conf && \
    sed -i "s#{SERVER_ROOT}#/var/preview#g" /etc/apache2/httpd.conf && \
    sed -i "s#{SERVER_ROOT}#/var/www/public/#g" /app/httpd.conf \
;fi

# Persistent runtime dependencies
# Example RUN apk add --no-cache php7-openssl php7-sysvmsg php7-curl

WORKDIR /var/www

COPY php.ini /etc/php7/php.ini
ARG DISPLAY_PHPERROR
RUN if [ ${DISPLAY_PHPERROR} = true ]; then \
sed -i "s#{DISPLAY}#On#g" /etc/php7/php.ini \
;else \
sed -i "s#{DISPLAY}#Off#g" /etc/php7/php.ini \
;fi

#Xdebug enable or disable
ARG XDEBUG
RUN if [ ${XDEBUG} = true ]; then \
apk add php7-pecl-xdebug \
&& echo "zend_extension=xdebug" >> /etc/php7/php.ini \
;fi

RUN apk add php7-zip
RUN apk add tar zip php7-gd php7-pdo php7-pdo_dblib php7-pdo_mysql php7-pdo_odbc php7-pdo_pgsql php7-pdo_sqlite php7-imap

COPY docker-entrypoint.sh /docker-entrypoint.sh
## Linux permission issue
ARG USER_ID
ARG GROUP_ID
RUN apk --no-cache add shadow unzip
RUN if [[ ${BACK_END} = nginx ]] ; then usermod -u ${USER_ID} nobody && groupmod -g ${GROUP_ID} nobody ; else usermod -u ${USER_ID} apache && groupmod -g ${GROUP_ID} apache ; fi

#Application Download
RUN curl -fLk -o /app/suite.zip  "https://suitecrm.com/files/147/SuiteCRM-8.0/608/SuiteCRM-8.0.3.zip"
RUN cd /app/ && unzip suite.zip && rm suite.zip 

RUN sed -i "s#{BACK_END}#${BACK_END}#g" /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
CMD /docker-entrypoint.sh & /sbin/runit-wrapper