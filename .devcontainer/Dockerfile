# syntax=docker/dockerfile:1.3-labs

FROM ghcr.io/trxcllnt/devcontainer-images:cmake-ninja-sccache-llvm15-cuda11.8-mambaforge as base

FROM base as amd64-files
ONBUILD ARG GITLAB_CLI_VERSION=1.24.1
ONBUILD ADD https://gitlab.com/gitlab-org/cli/-/releases/v${GITLAB_CLI_VERSION}/downloads/glab_${GITLAB_CLI_VERSION}_Linux_x86_64.deb /usr/local/src/gitlab-cli/gitlab-cli.deb

FROM base as arm64-files
ONBUILD ARG GITLAB_CLI_VERSION=1.24.1
ONBUILD ADD https://gitlab.com/gitlab-org/cli/-/releases/v${GITLAB_CLI_VERSION}/downloads/glab_${GITLAB_CLI_VERSION}_Linux_arm64.deb  /usr/local/src/gitlab-cli/gitlab-cli.deb

FROM ${TARGETARCH}-files as files

FROM base

SHELL ["/bin/bash", "-c"]

USER root

RUN --mount=type=bind,from=files,src=/usr/local/src/gitlab-cli,target=/usr/local/src/gitlab-cli \
<<EOF
DEBIAN_FRONTEND=noninteractive apt update;
DEBIAN_FRONTEND=noninteractive apt install    \
    -y --no-install-recommends                \
    jq wget numactl rlwrap                    \
    /usr/local/src/gitlab-cli/gitlab-cli.deb  \
    ;

gh completion -s bash | tee /etc/bash_completion.d/gh >/dev/null;
glab completion -s bash | tee /etc/bash_completion.d/glab >/dev/null;

mkdir -m 0755 -p /home/coder/{.cache,.conda,legion,legate,cunumeric};
chown -R coder:coder /home/coder;

sed -i -re 's/^HISTSIZE=.*$/HISTSIZE=;/g' /home/coder/.bashrc;
sed -i -re 's/^HISTFILESIZE=.*$/HISTFILESIZE=;/g' /home/coder/.bashrc;
cat <<EOF2 >> /home/coder/.bashrc
HISTFILE="/home/coder/.cache/._bash_history";
PROMPT_COMMAND="history -a; \$PROMPT_COMMAND";
mkdir -p "\$(dirname \$HISTFILE)";
touch "\$HISTFILE";
EOF2

rm -rf \
    /tmp/* \
    /var/tmp/* \
    /var/cache/apt/* \
    /var/lib/apt/lists/*; \

for x in clone-legion         \
         clone-legate-core    \
         make-legate-test-env ; do
    mkdir -p /opt/legate/bin;
    touch /opt/legate/bin/$x.sh;
    chmod +x /opt/legate/bin/$x.sh;
    update-alternatives --install /usr/bin/$x $x /opt/legate/bin/$x.sh 0;
done

EOF

SHELL ["/bin/bash", "-c"]

COPY --chown=coder:coder workspace.code-workspace /home/coder/

COPY --chown=root:root opt/legate /opt/legate
COPY --chown=root:root opt/devcontainer /opt/devcontainer

ENV SCCACHE_S3_USE_SSL=true
ENV SCCACHE_IDLE_TIMEOUT=32768

ENV PYTHONDONTWRITEBYTECODE=1
ENV CMAKE_C_COMPILER_LAUNCHER=/usr/bin/sccache
ENV CMAKE_CXX_COMPILER_LAUNCHER=/usr/bin/sccache
ENV CMAKE_CUDA_COMPILER_LAUNCHER=/usr/bin/sccache

USER coder
WORKDIR /home/coder
