#!/bin/bash

set -e

export KUBE_URL=${INPUT_KUBE_URL}
export KUBE_TOKEN=${INPUT_KUBE_TOKEN}
export KUBE_CA_PEM=${INPUT_KUBE_CA_PEM}
export KUBE_NAMESPACE=${INPUT_KUBE_NAMESPACE}
export CI_ENVIRONMENT_SLUG=${INPUT_CI_ENVIRONMENT_SLUG}
export CI_ENVIRONMENT_URL=${INPUT_CI_ENVIRONMENT_URL}
export CI_DEPLOY_USER=${INPUT_CI_DEPLOY_USER}
export CI_DEPLOY_PASSWORD=${INPUT_CI_DEPLOY_PASSWORD}
export CI_REGISTRY=${INPUT_CI_REGISTRY}
export CI_REGISTRY_IMAGE=${INPUT_CI_REGISTRY_IMAGE}
export CLUSTER=${INPUT_CLUSTER} 
# Print the input message
echo "Executing command: ${INPUT_COMMAND}"
echo "CI_REGISTRY_IMAGE is ${CI_REGISTRY_IMAGE}"
sh -c "${INPUT_COMMAND}"
