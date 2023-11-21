#!/bin/bash

# kind
# kind create cluster

# Pré-requisitos
# - Instalação do Kubernetes 1.12+
# - Instalação do Helm v3.0+

# Passo a passo

# Autenticação AKS
    az aks get-credentials --resource-group FIBRASIL-IT-US-UAT-APP-AKS-RG --name aksappuatus002 --overwrite-existing --admin

# 1. Criando namespace do apisix
    kubectl create namespace network-provisioner
    kubectl config set-context --current --namespace=network-provisioner

# 2. Adicionando repositório do Helm
    helm repo add apisix https://charts.apiseven.com
    helm repo update

# 3. Instalando apisix como uma aplicação no Kubernetes (Via Helm)

    # helm inspect values apisix/apisix > apisix/values.yaml

    helm upgrade --install apisix apisix/apisix --namespace network-provisioner

# 4. Instalando helm - dashboard

    # helm inspect values apisix/apisix-dashboard > apisix-dashboard/values.yaml

    helm upgrade --install apisix-dashboard apisix/apisix-dashboard --namespace network-provisioner --values apisix-dashboard/values.yaml

# --------------------------------------------------------------------------- #
# NÃO FOI INSTALADO O INGRESS-CONTROLLER, EM TODO CASO OS COMANDOS ESTÃO ABAIXO
# --------------------------------------------------------------------------- #

# # 5. Instalando helm - apisix-ingress-controller
# helm upgrade --install apisix-ingress-controller apisix/apisix-ingress-controller --namespace apisix
# export POD_NAME=$(kubectl get pods --namespace apisix -l "app.kubernetes.io/name=apisix-ingress-controller,app.kubernetes.io/instance=apisix-ingress-controller" -o jsonpath="{.items[0].metadata.name}")
# export CONTAINER_PORT=$(kubectl get pod --namespace apisix $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
# kubectl --namespace apisix port-forward $POD_NAME 8080:$CONTAINER_PORT
# # echo "Visit http://127.0.0.1:8080 to use your application"
