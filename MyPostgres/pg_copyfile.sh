cp /opt/*.conf $PGDATA && psql -U admin -d dbmain -c "select pg_reload_conf()"