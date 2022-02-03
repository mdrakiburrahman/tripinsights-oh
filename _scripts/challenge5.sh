# Add helm chart
helm repo add csi-secrets-store-provider-azure https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/charts

# Install helm charts with 
# 1. K8s secrets sync enabled
# 2. Auto rotation
# 3. Sync interval = 5s
helm install csi csi-secrets-store-provider-azure/csi-secrets-store-provider-azure --set secrets-store-csi-driver.syncSecret.enabled=true --set secrets-store-csi-driver.enableSecretRotation=true --set secrets-store-csi-driver.rotationPollInterval=5s

# AKV SPs
# Client ID: c4b8167d-3f52-41a4-8fb6-6ac6d0ff8e96
# Client Secret: iQk7Q~jrZEdU65YrjppQcpks7sboa9rjj~fGh

kubectl create secret generic secrets-store-creds --from-literal clientid='c4b8167d-3f52-41a4-8fb6-6ac6d0ff8e96' --from-literal clientsecret='iQk7Q~jrZEdU65YrjppQcpks7sboa9rjj~fGh'

# Label secret for CSI
kubectl label secret secrets-store-creds secrets-store.csi.k8s.io/used=true

# Validate
kubectl describe secret secrets-store-creds