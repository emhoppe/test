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
