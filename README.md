# test
#Os arquivos foram criados utilizando Docker Destop para produzir as imagens que usei, em ambiente Windows 10 e Minukube com Hyper-V configurado para 2 nodes, ou 2 VM's portanto. Estou usando Ingress

#O arquivo start.bat da o início ao Minikube e habilita o ingress

#Criei os arquivos .bat para rodar facilmente os arquivos YAML e dividi em partes para facilitar podendo ser chamado todo, ou parte 1, parte2 e parte3. Da mesma forma limpa1, limpa2, limpa3 ou limpa tudo.bat removem parte ou integralmente os componentes.

#A pasta Mynginx contém o docker file de montagem do Nginx que eu havia configurado antes de eu entender o uso com Ingress. Esta imagem agora não é mais necessaria, mas deixei como material extra do que eu havia feito.

#A pasta flask contém tudo que usei para testar Python e o flask e montar a imagem do Flask com o Docker para depois usar no Kubernetes

#Vários arquivos ali foram adicionados pelo venv então mantive.

#Caso não possa rodar o start.bat, segue:
minikube start --nodes 2 --vm-driver hyperv --hyperv-virtual-switch "Minikube"

#Como não consigo dar nomes uando o minikube os labels fazem a funcao:
kubectl label nodes minikube name=db-pool
kubectl label nodes minikube-m02 name=app-pool

minikube minikube addons enable ingress

#Parte 1:

#Rodar o arquivo parte1.bat ou os respectivos Yamls que estão listados nele:

kubectl apply -f CIPdb.yaml
#Cria um serviço clusterIP

kubectl apply -f configmap.yaml
#Cria o config map

kubectl apply -f PVmain.yaml
#Cria o volume main

kubectl apply -f PVreplica.yaml
#Cria o volume replica

Kubectl apply -f dbmain.yaml
#Cria o Postgres Main

Kubectl apply -f dbreplica.yaml
#Cria o Postgres Replica

kubectl apply -f loadbalance.yaml
#Cria o serviço de loadbalancer


#Parte2: 

#Rodar o arquvio parte2. bat ou os respectivos Yamls que estão listados nele:

Kubectl apply -f nginx.yaml
#Cria o nginx 

Kubectl apply -f flask.yaml
#Cria o flask com minha imagem

Kubectl apply -f ingres.yaml
#Cria o Ingress que fará o encaminhamento ao flask/nginx


