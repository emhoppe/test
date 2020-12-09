Kubectl delete statefulset db-main
Kubectl delete statefulset db-replica
kubectl delete pvc dbreplica-claim
kubectl delete pvc dbmain-pv-claim
kubectl delete pv dbreplica-pv
kubectl delete pv dbmain-pv

