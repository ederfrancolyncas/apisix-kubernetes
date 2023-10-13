#!/bin/bash

# Pré-requisitos
# - Instalação do Kubernetes 1.12+
# - Instalação do Helm v3.0+

# Passo a passo

# 1. Criando namespace do apisix
kubectl create namespace apisix
kubectl config set-context --current --namespace=apisix

# 2. Adicionando repositório do Helm
helm repo add apisix https://charts.apiseven.com
helm update

# 3. Instalando helm - apisix
helm upgrade --install apisix apisix/apisix --namespace apisix
export NODE_PORT=$(kubectl get --namespace apisix -o jsonpath="{.spec.ports[0].nodePort}" services apisix-gateway)
export NODE_IP=$(kubectl get nodes --namespace apisix -o jsonpath="{.items[0].status.addresses[0].address}")
export POD_NAME=$(kubectl get pods --namespace apisix -l "app.kubernetes.io/name=apisix,app.kubernetes.io/instance=apisix" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace apisix $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
kubectl --namespace apisix port-forward $POD_NAME 9080:$CONTAINER_PORT

# 4. Instalando helm - dashboard
helm upgrade --install apisix-dashboard apisix/apisix-dashboard --namespace apisix
export POD_NAME=$(kubectl get pods --namespace apisix -l "app.kubernetes.io/name=apisix-dashboard,app.kubernetes.io/instance=apisix-dashboard" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace apisix $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
kubectl --namespace apisix port-forward $POD_NAME 9000:$CONTAINER_PORT

# 5. Instalando helm - apisix-ingress-controller
helm upgrade --install apisix-ingress-controller apisix/apisix-ingress-controller --namespace apisix
export POD_NAME=$(kubectl get pods --namespace apisix -l "app.kubernetes.io/name=apisix-ingress-controller,app.kubernetes.io/instance=apisix-ingress-controller" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace apisix $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
kubectl --namespace apisix port-forward $POD_NAME 8080:$CONTAINER_PORT
# echo "Visit http://127.0.0.1:8080 to use your application"