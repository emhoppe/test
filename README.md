# test
# Os arquivos foram criados utilizando Docker Destop para produzir as imagens que usei, em ambiente Windows 10 e Minukube com Hyper-V configurado para 2 nodes, ou 2 VM's portanto. Estou usando Ingress

# O arquivo start.bat da o início ao Minikube e habilita o ingress

# Criei os arquivos .bat para rodar facilmente os arquivos YAML e dividi em partes para facilitar podendo ser chamado todo, ou parte 1, parte2 e parte3. Da mesma forma limpa1, limpa2, limpa3 ou limpa tudo.bat removem parte ou integralmente os componentes.

# A pasta Mynginx contém o docker file de montagem do Nginx que eu havia configurado antes de eu entender o uso com Ingress. Esta imagem agora não é mais necessaria, mas deixei como material extra do que eu havia feito.

# A pasta flask contém tudo que usei para testar Python e o flask e montar a imagem do Flask com o Docker para depois usar no Kubernetes.

# Vários arquivos ali foram adicionados ao criar o ambiente virtual então mantive.

# O postgres eu optei por criar uma imagem onde deixei alguns opcionais instalados para testes a edição. Copiei os arquvos de configuração configurados de forma a rodar de forma rápida depois a replicação, optando assim por usar o Docker e manter o teste com mais conhecimento demonstrado. Os arquivos vão para a pasta /opt 

# De forma a ficar fácil e ágil eu criei arquivos .bat com tudo o que precisa ser rodado, onde posso criar e limpar o ambiente todo sem falhas. A sequencia segue abaixo:

# start.bat - Inicializa o Minikue com a maquina virtual em 2 nodes e ativa o Ingress
minikube start --nodes 2 --vm-driver hyperv --hyperv-virtual-switch "Minikube"

# Como não consigo dar nomes aos nodes uando o minikube os labels fazem a funcao e ficam associados corretamente através de selector posteriormente. Achei muito interessante a forma como o Kubernetes oferece isso:

kubectl label nodes minikube name=db-pool
kubectl label nodes minikube-m02 name=app-pool

# Ingress
minikube minikube addons enable ingress

# Teste Parte 1:

# Rodar o arquivo parte1.bat ou os respectivos Yamls que estão listados nele:

# Cria um serviço clusterIP para a comunicação interna dos Postgres
kubectl apply -f CIPdb.yaml

# Cria o config map. Observe que separei, pois inicialmente eu de fato passava nomes diferentes para testar as bases e mantive apenas para aproveitar e poder aprofundar na forma como os selector e labels nos ajudam a vincular os componentes. usei o label "tier" para fazer uma diferenciacao, onde no restante eu uso o label "app".
kubectl apply -f configmap.yaml

# Cria o volume main e seu claim. Observe que reduzi para 2gb apenas por questões minhas aqui de VM e espaço sem alterar a proposta do teste.
kubectl apply -f PVmain.yaml

# Cria o volume replica e seu claim
kubectl apply -f PVreplica.yaml

# Cria o servidor Postgres Main utilizando minha imagem pré configurada.
Kubectl apply -f dbmain.yaml

# Cria o Postgres Replica
Kubectl apply -f dbreplica.yaml

# Cria o serviço de loadbalancer solicitado. Inclusive estou estudando uma forma de usar esta base para alguma aplicação minha e aprofundar este teste posteriormente. Estou vendo o Django para um front web
kubectl apply -f loadbalance.yaml

# Após ter os pods rodando podemos finalizar a parte 1 rodando a configuração da replicação e onde crio uma tabela para podermos ver na prática. Caso prefira os Execs estão listados um a um abaixo.
kube exec.bat

# Este exec copia os 2 arquivos configurados(postgresql.conf e pg_hba.conf) para a pasta $PGDATA e da um refresh no config com o comando select pg_reload_conf()
kubectl exec db-main-0 -- /bin/bash /opt/pg_copyfile.sh

# Aqui crio os usuários e a tabela para podermos ver a replicação
kubectl exec db-main-0 -- /bin/bash /opt/tabelas.sh

# Este comando dispara o backup em si que ao terminar deixa o replica pronto. Em alguns instantes basta rodar o teste e confirmar que a replicação está funcional
kubectl exec db-replica-0 -- /bin/bash /opt/pg_backup.sh

# replicatest.bat Apenas para um teste e visualização posterior as etapas anteriores
kubectl exec db-main-0 -- psql -U admin -d dbmain -x -c "select * from pg_stat_replication"


# Parte2: 

# Rodar o arquvio parte2. bat ou os respectivos Yamls que estão listados nele:

# Cria o nginx
Kubectl apply -f nginx.yaml

# Cria o flask com minha imagem onde ele exibirá uma linha contendo data e o nome do Pod
Kubectl apply -f flask.yaml

# Cria o Ingress que fará o encaminhamento ao flask/nginx para tanto basta adicionar /flask na url para o flask ou nada para o Nginx
Kubectl apply -f ingres.yaml

#Parte 3 

# Rodar o parte3.bat que cria os 2 cronjobs

# Criei o back mapeando os 2 volumes, rodando o PG_basebackup novamente sem as opções específicas para replicação. Não usei o Pg_dump porque foi solicitiado backup do servidor e não apenas da base de dados. Configurei o job para 30 min mantendo 2 pods
kubectl apply -f .\cronback.yaml

# Neste eu criei o job para 5 minutos onde exibo a data solicitada mantendo 2 pods para comparação
kubectl apply -f .\crondate.yaml

# Uma vez tudo pronto e não sendo necessário manter basta executar o limpa tudo.bat
Kubectl delete statefulset db-main
Kubectl delete statefulset db-replica
kubectl delete pvc dbreplica-pv-claim
kubectl delete pvc dbmain-pv-claim
kubectl delete pv dbreplica-pv
kubectl delete pv dbmain-pv
kubectl delete svc postgres
kubectl delete svc postgreslb
kubectl delete configmap dbconfigmain
kubectl delete configmap dbconfigreplica
Kubectl delete deployment mynginx
Kubectl delete deployment flaskpy
kubectl delete svc connectsvc
kubectl delete ingress flasking
kubectl delete cronjob cronback
kubectl delete cronjob crondate

# Como estamos lidando com volumes persistentes enquanto os nodes existirem os volumes ficam preservados. Fiz diversos testes de "deleção" e a não ser que forçadamente se apague o que está nos volumes, está garantido que fica preservado independente de qualquer falha ou mesmo da desmontagem com o bat de limpeza.

# Observei que caso se apague toda a pasta $PGDATA manualmente o container será recriado zerado, ai sim perdendo as informações, mas o servidor voltará a sua operação. Tendo sido rodado o backup, ou tendo a replica ainda, tudo pode ser recuperado. Achei sensacional a forma e a agilidade disto.

# comandos.txt
# Este arquivo é apenas uma referência com alguns comandos que utilizo durante o teste.

# Concluo agradecendo a oportunidade ficando a disposição! Foi um estudo intenso onde traçei metas que me demandaram entrar madrugadas diversas vezes, ler muito, persistir muito e agradeço todo o apoio e orientações! Um desafio que concluo com alegria e que tenho certeza me agregou muito. Se começei com 0 conhecimento em containers hoje já me considero avançado e pronto para ir além! Foi não só válido para isso como para Linux e Posrtgres também que já estou estudandod