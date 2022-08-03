#!/bin/bash

# exit when any command fails
set -e

# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT

# Extract the base64 encoded config data and write this to the KUBECONFIG

whoami
pwd
chown -R $(whoami):$(whoami) /github/workspace
echo "git log -1 -p"
git log -1 -p
echo "----------------------------------"
echo "git show HEAD"
git show HEAD

echo "----------------------------------"
# git log -1 -p |grep +++|cut -d/ -f2
# FILES=$(git show HEAD|grep +++|cut -d/ -f2-)
FILES=$(git log -1 -p |grep +++|cut -d/ -f2-)
echo "Files: $FILES"

# export SERVICE="$(git log -1 -p |grep +++|cut -d/ -f2)"
echo "$KUBE_CONFIG_DATA" | base64 --decode > /tmp/config
export KUBECONFIG=/tmp/config

kubectl config current-context
kubectl get nodes
ls -la

for i in $FILES
do 
    kubectl apply -f $i
done
    

# kubectl apply -f services --recursive

# Dns=$(find ./$SERVICE/ -type f -name "coredns*")
# Namespace=$(find ./$SERVICE/ -type f -name "namespace*")
# Configmap=$(find ./$SERVICE/ -type f -name "configmap*")
# Secret=$(find ./$SERVICE/ -type f -name "secret.y*")
# Deployment=$(find ./$SERVICE/ -type f -name "deployment.y*ml")
# Service=$(find ./$SERVICE/ -type f -name "service.y*ml")
# Ingress=$(find ./$SERVICE/ -type f -name "ingress.y*ml")
# RBAC=$(find ./$SERVICE/ -type f -name "rbac.y*ml")
# PODMONITOR=$(find ./$SERVICE/ -type f -name "podmonitor.y*ml")
# SERVICEMONITOR=$(find ./$SERVICE/ -type f -name "servicemonitor.y*ml")

# for dns in $Dns
# do
#     kubectl apply -f $dns
# done

# for namespace in $Namespace
# do
#     kubectl apply -f $namespace
# done

# for configmap in $Configmap
# do
#     kubectl apply -f $configmap
# done

# for secret in $Secret
# do
#     kubectl apply -f $secret
# done

# for deployment in $Deployment
# do
#     kubectl apply -f $deployment
# done

# for service in $Service
# do
#     kubectl apply -f $service
# done

# for ingress in $Ingress
# do
#     kubectl apply -f $ingress
# done

# for rbac in $RBAC
# do
#     kubectl apply -f $rbac
# done

# for podmonitor in $PODMONITOR
# do
#     kubectl apply -f $podmonitor
# done

# for servicemonitor in $SERVICEMONITOR
# do
#     kubectl apply -f $servicemonitor
# done

rm /tmp/config
