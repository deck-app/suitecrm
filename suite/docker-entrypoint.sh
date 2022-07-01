#!/bin/bash

set +x
if [ -d "/var/www/vendor" ]
then
    cd /var/www/
    # composer install
    # echo "Dependencies updated"
else  
    cd /var/www
    echo >&2 "SuiteCRM not found in $(pwd) - Create apps please patience..."
    tar cf - --one-file-system -C /app/ . | tar xf -
    HOST=`hostname`
    NAME=`echo $HOST | sed 's:.*-::'`
    chmod -R 755 /var/www/ 2> /dev/null
fi

rm -rf /var/preview
if [[ {BACK_END} = nginx ]]  ; 
then
    cp /app/default.conf /etc/nginx/conf.d/default.conf
    nginx -s reload
    chown -R nobody:nobody /var/www 2> /dev/null
else
    cp /app/httpd.conf /etc/apache2/httpd.conf
    httpd -k graceful
    chown -R apache:apache /var/www 2> /dev/null
fi

rm -rf /var/preview
rm -rf /app/default.conf
exec "$@"