#! /usr/bin/env bash

# mamba create -n cunumeric_build python=$PYTHON_VERSION boa git

cd $(dirname "$(realpath "$0")")/..

mkdir -p /tmp/conda-build/cunumeric
rm -rf /tmp/conda-build/cunumeric/*

PYTHON_VERSION="${PYTHON_VERSION:-3.9}"

CUDA="$(nvcc --version | head -n4 | tail -n1 | cut -d' ' -f5 | cut -d',' -f1).*" \
conda mambabuild \
    --numpy 1.22 \
    --python $PYTHON_VERSION \
    --override-channels \
    -c file:///tmp/conda-build/legate_core \
    -c conda-forge -c nvidia \
    --croot /tmp/conda-build/cunumeric \
    --prefix-length 3 \
    --no-test \
    --no-verify \
    --build-id-pat='' \
    --merge-build-host \
    --no-include-recipe \
    --no-anaconda-upload \
    --output-folder /tmp/conda-build/cunumeric \
    --variants "{gpu_enabled: 'true', python: $PYTHON_VERSION}" \
    ./conda/conda-build
