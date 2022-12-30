#! /usr/bin/env bash

CUDA_VERSION=${CUDA_VERSION:-11.8}

if [ -z "$PYTHON_VERSION" ]; then
    PYTHON_VERSION="$(python3 --version 2>&1 | cut -d' ' -f2 | cut -d'.' -f3 --complement)"
fi

env_yaml="/tmp/environment-test-linux-py${PYTHON_VERSION}-cuda${CUDA_VERSION}-compilers-openmpi.yaml"

# Use a consistent name and assume re-running `make-legate-test-env` after switching
# branches will be fast because we use mamba and most packages will be in the local
# conda package cache.
env_name="legate"

/opt/legate/bin/clone-legion;
/opt/legate/bin/clone-legate-core;

(
    cd /tmp

    $HOME/legate.core/scripts/generate-conda-envs.py \
        --ctk ${CUDA_VERSION} \
        --python ${PYTHON_VERSION} \
        --os linux --compilers --openmpi

    cat << EOF >> "$env_yaml"
  - debugpy
EOF
)

sed -i -re "s/legate-test/$env_name/g" "$env_yaml";
# Remove clang and clang-tools from the conda env
sed -i -re "s/^(\s+\- clang(-tools)?)(.*?)$//g" "$env_yaml";

if [[ "$(conda info -e | grep -q "$env_name"; echo $?)" == 0 ]];
then mamba env update -n "$env_name" -f "$env_yaml";
else mamba env create -n "$env_name" -f "$env_yaml";
fi

. /opt/conda/etc/profile.d/conda.sh && conda activate "$env_name";

skbuild_dir="$(python -c 'import skbuild; print(skbuild.constants.SKBUILD_DIR())')";

cat <<EOF > $HOME/.clangd
If:
  PathMatch: .*\.cuh?
CompileFlags:
  Add:
    - -stdlib=libstdc++
---
If:
  PathMatch: legate\.core/.*
CompileFlags:
  CompilationDatabase: $HOME/legate.core/${skbuild_dir}/cmake-build
---
If:
  PathMatch: cunumeric/.*
CompileFlags:
  CompilationDatabase: $HOME/cunumeric/${skbuild_dir}/cmake-build
EOF
