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
Deployment=$(find . -type f -name "deployment.y*ml")
Service=$(find . -type f -name "service.y*ml")
Ingress=$(find . -type f -name "ingress.y*ml")
RBAC=$(find . -type f -name "rbac.y*ml")
PODMONITOR=$(find . -type f -name "podmonitor.y*ml")
SERVICEMONITOR=$(find . -type f -name "servicemonitor.y*ml")

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

for podmonitor in $PODMONITOR
do
    kubectl apply -f $podmonitor
done

for servicemonitor in $SERVICEMONITOR
do
    kubectl apply -f $servicemonitor
done

rm /tmp/config
