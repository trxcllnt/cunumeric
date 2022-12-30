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

SHELL ["/bin/bash", "-Eeox", "pipefail", "-c"]

USER root

RUN --mount=type=bind,from=files,src=/usr/local/src/gitlab-cli,target=/usr/local/src/gitlab-cli \
<<EOF
DEBIAN_FRONTEND=noninteractive apt update;
DEBIAN_FRONTEND=noninteractive apt install    \
    -y --no-install-recommends                \
    jq wget numactl rlwrap                    \
    /usr/local/src/gitlab-cli/gitlab-cli.deb  \
    ;

mkdir -m 0777 -p /workspaces /workspaces/{.cache,.conda,legion,legate,cunumeric};

rm -rf /home/coder/.{cache,conda};
ln -s /workspaces/.cache /home/coder/.cache;
ln -s /workspaces/.conda /home/coder/.conda;
ln -s /workspaces/legion /home/coder/legion;
ln -s /workspaces/legate /home/coder/legate;
ln -s /workspaces/cunumeric /home/coder/cunumeric;

sed -i -re 's/^HISTSIZE=.*$/HISTSIZE=;/g' /home/coder/.bashrc; \
sed -i -re 's/^HISTFILESIZE=.*$/HISTFILESIZE=;/g' /home/coder/.bashrc; \
cat <<EOF2 >> /home/coder/.bashrc
HISTFILE="/workspaces/.cache/._bash_history";
PROMPT_COMMAND="history -a; \$PROMPT_COMMAND";
mkdir -p "\$(dirname \$HISTFILE)";
touch "\$HISTFILE";
EOF2

rm -rf \
    /tmp/* \
    /var/tmp/* \
    /var/cache/apt/* \
    /var/lib/apt/lists/*; \

EOF

SHELL ["/bin/bash", "-c"]

COPY --chown=coder:coder workspace.code-workspace /home/coder/

COPY --chown=root:root bin/clone-legion.sh /opt/legate/bin/clone-legion
COPY --chown=root:root bin/clone-github-repo.sh /opt/legate/bin/clone-github-repo
COPY --chown=root:root bin/clone-gitlab-repo.sh /opt/legate/bin/clone-gitlab-repo
COPY --chown=root:root bin/clone-legate-core.sh /opt/legate/bin/clone-legate-core
COPY --chown=root:root bin/make-legate-test-env.sh /opt/legate/bin/make-legate-test-env
COPY --chown=root:root bin/open-vscode-workspace.sh /opt/legate/bin/open-vscode-workspace

ENV SCCACHE_S3_USE_SSL=true
ENV SCCACHE_IDLE_TIMEOUT=32768

ENV PYTHONDONTWRITEBYTECODE=1
ENV PATH="${PATH}:/opt/legate/bin"
ENV CMAKE_C_COMPILER_LAUNCHER=/usr/bin/sccache
ENV CMAKE_CXX_COMPILER_LAUNCHER=/usr/bin/sccache
ENV CMAKE_CUDA_COMPILER_LAUNCHER=/usr/bin/sccache

USER coder
WORKDIR /home/coder
