FROM ghcr.io/trxcllnt/devcontainer-images/cmake-ninja-sccache-llvm-cuda-mambaforge:latest

USER root
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    jq moreutils numactl rlwrap \
 && mkdir -p /workspaces \
 && chmod 0777 /workspaces \
 && rm -rf /tmp/* /var/tmp/*

COPY bin/clone-legate-core.sh /opt/legate/bin/clone-legate-core
COPY bin/make-legate-test-env.sh /opt/legate/bin/make-legate-test-env

ENV MAMBA_NO_BANNER=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PATH="${PATH}:/opt/legate/bin"
ENV CMAKE_C_COMPILER_LAUNCHER=/usr/bin/sccache
ENV CMAKE_CXX_COMPILER_LAUNCHER=/usr/bin/sccache
ENV CMAKE_CUDA_COMPILER_LAUNCHER=/usr/bin/sccache
