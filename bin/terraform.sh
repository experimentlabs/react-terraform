#!/bin/bash

set -euo pipefail

COMMAND=${1:-plan}
OPTS=
[ "$COMMAND" = plan ] || OPTS=-auto-approve

STATE="data/state.tfstate"
# k8slvl3/terraform/cluster-provision
MODULE="./terraform/"

export TF_VAR_region=${AWS_REGION}

terraform init $MODULE

terraform $COMMAND $OPTS \
-var-file="data/params.tfvars" \
-state="$STATE" -refresh=true $MODULE

