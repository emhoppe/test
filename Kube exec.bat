kubectl exec db-main-0 -- /bin/bash /opt/pg_copyfile.sh

kubectl exec db-main-0 -- /bin/bash /opt/tabelas.sh

kubectl exec db-replica-0 -- /bin/bash /opt/pg_backup.sh
