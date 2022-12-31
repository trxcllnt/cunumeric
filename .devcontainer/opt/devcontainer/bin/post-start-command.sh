#! /usr/bin/env bash

/opt/devcontainer/bin/init-git.sh;

for cmd in $(find /opt -type f -name post-start-command.sh ! -wholename $0); do
    . $cmd;
done

/opt/devcontainer/bin/open-vscode-workspace.sh;
