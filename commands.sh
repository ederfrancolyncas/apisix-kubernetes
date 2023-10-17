#!/bin/bash

# kind
# kind create cluster

# Pré-requisitos
# - Instalação do Kubernetes 1.12+
# - Instalação do Helm v3.0+

# Passo a passo

# 1. Criando namespace do apisix
    kubectl create namespace apisix
    kubectl config set-context --current --namespace=apisix

# 2. Adicionando repositório do Helm
    helm repo add apisix https://charts.apiseven.com
    helm repo update

# 3. Instalando apisix como uma aplicação no Kubernetes (Via Helm)

    helm upgrade --install apisix apisix/apisix --namespace apisix

    export POD_NAME=$(kubectl get pods --namespace apisix -l "app.kubernetes.io/name=apisix,app.kubernetes.io/instance=apisix" -o jsonpath="{.items[0].metadata.name}")

    kubectl --namespace apisix port-forward $POD_NAME 9080:9080

# 4. Instalando helm - dashboard

    # helm inspect values apisix/apisix-dashboard > apisix-dashboard/values.yaml

    helm upgrade --install apisix-dashboard apisix/apisix-dashboard --namespace apisix --values apisix-dashboard/values.yaml
    
    export POD_NAME=$(kubectl get pods --namespace apisix -l "app.kubernetes.io/name=apisix-dashboard,app.kubernetes.io/instance=apisix-dashboard" -o jsonpath="{.items[0].metadata.name}")
    
    kubectl --namespace apisix port-forward $POD_NAME 9000:9000



# --------------------------------------------------------------------------- #
# NÃO FOI INSTALADO O INGRESS-CONTROLLER, EM TODO CASO OS COMANDOS ESTÃO ABAIXO
# --------------------------------------------------------------------------- #

# # 5. Instalando helm - apisix-ingress-controller
# helm upgrade --install apisix-ingress-controller apisix/apisix-ingress-controller --namespace apisix
# export POD_NAME=$(kubectl get pods --namespace apisix -l "app.kubernetes.io/name=apisix-ingress-controller,app.kubernetes.io/instance=apisix-ingress-controller" -o jsonpath="{.items[0].metadata.name}")
# export CONTAINER_PORT=$(kubectl get pod --namespace apisix $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
# kubectl --namespace apisix port-forward $POD_NAME 8080:$CONTAINER_PORT
# # echo "Visit http://127.0.0.1:8080 to use your application"
