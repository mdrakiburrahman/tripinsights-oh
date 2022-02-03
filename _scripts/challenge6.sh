# Monitoring namespace
kubectl create ns monitoring

# Add the stable repo for Helm 3
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# CRD delete
kubectl delete crd alertmanagerconfigs.monitoring.coreos.com
kubectl delete crd alertmanagers.monitoring.coreos.com
kubectl delete crd podmonitors.monitoring.coreos.com
kubectl delete crd probes.monitoring.coreos.com
kubectl delete crd prometheuses.monitoring.coreos.com
kubectl delete crd prometheusrules.monitoring.coreos.com
kubectl delete crd servicemonitors.monitoring.coreos.com
kubectl delete crd thanosrulers.monitoring.coreos.com

# Install Prometheus Operator
helm install prometheus-operator prometheus-community/kube-prometheus-stack --namespace monitoring 
kubectl -n monitoring get all -l "release=prometheus-operator"

# Check to see that all the Pods are running
kubectl get pods -n monitoring

# Other Useful Prometheus Operator Resources to Peruse
kubectl get prometheus -n monitoring
kubectl get prometheusrules -n monitoring
kubectl get servicemonitor -n monitoring
kubectl get cm -n monitoring
kubectl get secrets -n monitoring

# Expose service as LoadBalancer
kubectl edit service prometheus-operator-grafana -n monitoring