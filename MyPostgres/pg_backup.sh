#Limpa a pasta, faz o backup e ativa a replicação
rm -f -r /$PGDATA/* && pg_basebackup -h db-main-0.postgres.default.svc.cluster.local -U replicator -p 5432 -D $PGDATA -Fp -Xs -P -R