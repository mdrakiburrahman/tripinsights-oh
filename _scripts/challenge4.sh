# Create namespaces
kubectl create ns web
kubectl create ns api

cd deployments/roles
# Create role: web-admin
kubectl apply -f web-admin.yaml

# Create role: web-viewer
kubectl apply -f web-viewer.yaml

# Create role: api-admin
kubectl apply -f api-admin.yaml

# Create role: api-viewer
kubectl apply -f api-viewer.yaml

##############
# AD Groups
##############
# web-dev
# api-dev

#######
# temp1
#######
# AD Group: web-admin

# Expectation:
# Full access to Web NS
# Read access to API NS

# Create rolebinding
cd ../roleBinding 
kubectl apply -f web-dev-binding.yaml

# Create roles
cd ../roles
kubectl apply -f api-admin.yaml
kubectl apply -f api-viewer.yaml
kubectl apply -f web-admin.yaml
kubectl apply -f web-viewer.yaml
