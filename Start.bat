minikube start --nodes 2 --vm-driver hyperv --hyperv-virtual-switch "Minikube"
kubectl label nodes minikube name=db-pool
kubectl label nodes minikube-m02 name=app-pool