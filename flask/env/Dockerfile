# Container com Python adaptado por mim
FROM python:3.10-rc-buster

#porta do flask
EXPOSE 5000

# Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1

#Define meu app server.py como padrao pro flask
ENV FLASK_APP=server.py
# Instala os requirements
ADD requirements.txt .

# Adicionei algumas modificacoes para atualizar e testar conexoes
RUN apt update && apt upgrade -y
RUN apt install curl -y
RUN apt install nano -y
RUN apt install iputils-ping -y

#Instala os requirements do que achei no Flask
RUN python -m pip install -r requirements.txt

#cria e adiciona os arquivos pro flask
WORKDIR /app
ADD . /app

# Troquei para um usuario nao root
RUN useradd flaskuser && chown -R flaskuser /app
USER flaskuser

#teste usando o guicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "server:app"]

#teste direto
#CMD ["flask", "run"]