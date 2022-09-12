#!/bin/bash

#Instalations
echo -e "${YELLOW}Installing nginx${NC}"
apt-get install nginx php8.1-fpm --yes;

echo -e "${YELLOW}Installing php5-curl${NC}"
apt-get install php8.1-curl --yes;

echo -e "${YELLOW}Installing postgres${NC}"
apt-get install postgresql --yes;

#Configuring Nginx
echo -e "${YELLOW}Configuring Nginx${NC}"
touch /etc/nginx/sites-available/test.local
cat > /etc/nginx/sites-available/test.local <<\eof
server {
        listen 80;
        server_name    localhost;
        root  /var/www/html;


        index index.php;
        # add_header Access-Control-Allow-Origin *;


        # serve static files directly
        location ~* \.(jpg|jpeg|gif|css|png|js|ico|html)$ {
                access_log off;
                expires max;
                log_not_found off;
        }


        location / {
                # add_header Access-Control-Allow-Origin *;
                try_files $uri $uri/ /index.php?$query_string;
        }

        location ~* \.php$ {
        try_files $uri = 404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
                deny all;
        }
}
eof

ln -s /etc/nginx/sites-available/test.local /etc/nginx/sites-enabled
unlink /etc/nginx/sites-enabled/default

echo -e "${YELLOW}DONE!${NC}"

#configuring PHP
echo -e "${YELLOW}Configuring PHP${NC}"
touch /var/www/html/info.php

cat > /var/www/html/info.php <<\eof
<?php
phpinfo();

eof

systemctl restart nginx
systemctl restart php8.1-fpm

echo -e "${YELLOW}DONE${NC}"
