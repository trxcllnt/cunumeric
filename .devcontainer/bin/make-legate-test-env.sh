#! /usr/bin/env bash

CUDA_VERSION=${CUDA_VERSION:-11.8}

if [ -z "$PYTHON_VERSION" ]; then
    PYTHON_VERSION="$(python3 --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f3 --complement)"
fi

env_yaml="environment-test-linux-py${PYTHON_VERSION}-cuda${CUDA_VERSION}-compilers-openmpi.yaml"

# We can do this if we want a conda env per cunumeric branch.
# However, that will change the include paths so new branches
# won't benefit from sccache the first time they're built.
# env_name="legate-test-$(cd /workspaces/cunumeric; git rev-parse --abbrev-ref HEAD)"
# env_name="${env_name//\//_}"

# Use a consistent name and assume re-running `make-legate-test-env` after switching
# branches will be fast because we use mamba and most packages will be in the local
# conda package cache.
env_name="legate-test"

/opt/legate/bin/clone-legate-core;

(
    cd /tmp

    /workspaces/legate.core/scripts/generate-conda-envs.py \
        --ctk ${CUDA_VERSION} \
        --python ${PYTHON_VERSION} \
        --os linux --compilers --openmpi

    cat << EOF >> "$env_yaml"
  - debugpy
EOF
)

sed -ri "s/legate-test/$env_name/g" "/tmp/$env_yaml";

if [[ "$(conda info -e | grep -q $env_name; echo $?)" == 0 ]]; \
then mamba env update -n $env_name -f "/tmp/$env_yaml"; \
else mamba env create -n $env_name -f "/tmp/$env_yaml"; \
fi

sed -ri "s/conda activate base/conda activate $env_name/g" ~/.bashrc;
