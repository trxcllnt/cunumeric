#! /usr/bin/env bash

if [[ ! -d ~/legion/.git ]]; then
    /opt/devcontainer/bin/clone-gitlab-repo.sh "StanfordLegion" "legion";
fi
