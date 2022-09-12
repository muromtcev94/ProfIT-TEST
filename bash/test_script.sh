#!/bin/bash

#Instalations
echo -e "${YELLOW}Installing nginx${NC}"
apt-get install nginx php7.4-fpm --yes;

echo -e "${YELLOW}Installing php5-curl${NC}"
apt-get install php7.4-curl --yes;

echo -e "${YELLOW}Installing postgres${NC}"
apt-get install postgresql --yes;

#Configuring Nginx
echo -e "${YELLOW}Configuring Nginx${NC}"
sudo touch /etc/nginx/sites-available/test.local
cat > /etc/nginx/sites-available/test.local <<\eof
server {
        listen 80; # порт, прослушивающий nginx
        server_name    test.local; # доменное имя, относящиеся к текущему виртуальному хосту
        root  /home/user/test/test.local; # каталог в котором лежит проект, путь к точке входа


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
        fastcgi_pass unix:/var/run/php/php8.1-fpm.sock; # подключаем сокет php-fpm
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.ht {
                deny all;
        }
}
eof

sudo ln -s /etc/nginx/sites-available/test.local /etc/nginx/sites-enabled

echo "127.0.0.1	test.local" >> /etc/hosts

echo -e "${YELLOW}DONE!${NC}"

#configuring PHP
echo -e "${YELLOW}Configuring PHP${NC}"
mkdir /home/user/test/test.local
sudo chmod -R 777 /home/user/test/test.local
touch /home/user/test/test.local/index.php
cat > /home/user/test/test.local/index.php <<\eof
<?php$

	echo "Test Prof-IT!";

eof
echo -e "${YELLOW}DONE${NC}"