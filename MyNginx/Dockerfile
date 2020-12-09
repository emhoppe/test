# Container com Nginx adaptado por mim
FROM nginx:latest

# porta do Nginx
EXPOSE 80

# Adicionei para testar posteriormente dentro do container
RUN apt update && apt upgrade -y
RUN apt install curl -y
RUN apt install nano -y
RUN apt install iputils-ping -y

WORKDIR /usr/share/nginx/html
COPY ./index.html .

WORKDIR /etc/nginx
ADD . /etc/nginx
