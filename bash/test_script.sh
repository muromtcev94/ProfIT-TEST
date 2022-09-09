#!/bin/bash

apt-get update && apt-get upgrade -y
clear
echo -e "${YELLOW}Installing nginx${NC}"
apt-get install nginx php8.1-fpm --yes;

echo -e "${YELLOW}Installing php5-curl${NC}"
apt-get install php8.1-curl --yes;

echo -e "${YELLOW}Installing postgres${NC}"
apt-get install postgresql --yes;
