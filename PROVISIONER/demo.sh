#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <source_file> 
    <private_key_path>"
    exit 1
fi

KEY_NAME=$1
PRIVATE_KEY_PATH=$2

terraform init
terraform apply -auto-approve -var="key_name=$KEY_NAME" -var="private_key_path=$PRIVATE_KEY_PATH"