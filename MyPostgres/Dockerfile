# Container com Python adaptado por mim
FROM postgres:13.1

#porta do postgres
EXPOSE 5432

# Adicionei algumas modificacoes para atualizar e testar conexoes
RUN apt update && apt upgrade -y
RUN apt install nano -y
RUN apt install iputils-ping -y
RUN apt install sudo -y

#cria e adiciona os arquivos pro Postgres que preciso ajustar para a replicacao
WORKDIR /opt
ADD . /opt

WORKDIR /var/lib/postgresql/data

# Troca para usuario postgres
#USER postgres

