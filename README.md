# test
Os arquivos foram criados utilizando Docker Destop comParte 1m Windows 10 e Minukube com Hyper-V configurado de acordo com a necessiade 1 ou 2 nodes.

Criei os arquivos .bat para rodar facilmente os arquivos YAML que precisava, seja para remover ou criar a estrutura toda.

A pasta Mynginx contém o docker file de montage do Nginx que eu ajustei

A pasta flask contém tudo que usei para testar Python e o flask e montar a imagem do Flask com o Docker para depois usar no Kubernetes
Vários arquivos ali foram adicionados pelo venv então mantive.

Para o minikube e os pods considerando o ambiente que utilizei descrito acima rodar o start.bat ou:

minikube start --nodes 2 --vm-driver hyperv --hyperv-virtual-switch "Minikube"
kubectl label nodes minikube name=db-pool
- Como não consigo dar nomes uando o minikube os labels fazem a funcao
kubectl label nodes minikube-m02 name=app-pool

Parte 1:

Rodar o arquivo parte1.bat ou os respectivos Yamls que estão listados nele:

kubectl apply -f CIPdb.yaml
-Cria um serviço clusterIP
kubectl apply -f configmap.yaml
-Cria o config map
kubectl apply -f PVmain.yaml
-Cria o volume main
kubectl apply -f PVreplica.yaml
-Cria o volume replica
Kubectl apply -f dbmain.yaml
-Cria o Postgres Main
Kubectl apply -f dbreplica.yaml
-Cria o Postgres Replica


Parte2: 
Rodar o arquvio parte2. bat ou os respectivos Yamls que estão listados nele:
Kubectl apply -f nginx.yaml
- Cria o nginx com minha imagem
Kubectl apply -f flask.yaml
- Cria o flask com minha imagem
Kubectl apply -f loadbalance.yaml
- Cria o loadbalancer para oa acesso ao Nginx
