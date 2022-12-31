#! /usr/bin/env bash

for cmd in $(find /opt -type f -name post-attach-command.sh ! -wholename $0); do
    . $cmd;
done

/opt/devcontainer/bin/open-vscode-workspace.sh;
