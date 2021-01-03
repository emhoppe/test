from flask import Flask
from datetime import datetime
import re
import os
import socket

app = Flask(__name__)

@app.route("/")
def home():
    return "Flask está ativo!"

@app.route("/<name>")
def hello_there(name):
    now = datetime.now()
    formatted_now = now.strftime("%A, %d %B, %Y at %X")

    # Testa entrada e caso seja invalida formata um default
    match_object = re.match("[a-zA-Z]+", name)
    
    hostname = socket.gethostname()

    if match_object:
        clean_name = match_object.group(0)
    else:
        clean_name = "amigo"
   
    content = "Flask Container recebeu: " + clean_name + "! Data e hora: " + formatted_now + ". Este é o pod: " + hostname 
    return content
    