#!/bin/bash

# exit when any command fails
set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "$KUBE_CONFIG_DATA" | base64 --decode > /tmp/config
export KUBECONFIG=/tmp/config

kubectl config current-context
kubectl get nodes
ls -la

# kubectl apply -f services --recursive

Dns=$(find . -type f -name "coredns*")
Namespace=$(find . -type f -name "namespace*")
Configmap=$(find . -type f -name "configmap*")
Secret=$(find . -type f -name "secret.y*")
Deployment=$(find . -type f -name "deployment.y*")
Service=$(find . -type f -name "service.y*")
Ingress=$(find . -type f -name "ingress.y*")
RBAC=$(find . -type f -name "rbac.y*")

for dns in $Dns
do
    kubectl apply -f $dns
done

for namespace in $Namespace
do
    kubectl apply -f $namespace
done

for configmap in $Configmap
do
    kubectl apply -f $configmap
done

for secret in $Secret
do
    kubectl apply -f $secret
done

for deployment in $Deployment
do
    kubectl apply -f $deployment
done

for service in $Service
do
    kubectl apply -f $service
done

for ingress in $Ingress
do
    kubectl apply -f $ingress
done

for rbac in $RBAC
do
    kubectl apply -f $rbac
done

rm /tmp/config
